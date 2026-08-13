import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/page_transitions.dart';
import '../widgets/scanner_overlay.dart';
import '../widgets/sound.dart';
import '../state/bookings_store.dart';
import 'visit_confirmed_screen.dart';

class FaceScanScreen extends StatefulWidget {
  final ScheduleItem item;
  const FaceScanScreen({super.key, required this.item});

  @override
  State<FaceScanScreen> createState() => _FaceScanScreenState();
}

class _FaceScanScreenState extends State<FaceScanScreen> with SingleTickerProviderStateMixin {
  CameraController? _camController;
  late final FaceDetector _detector;
  late final AnimationController _sweep;
  bool _busy = false;
  bool _handled = false;
  bool _confirming = false;
  bool _initFailed = false;
  bool _controllerDisposed = false;
  DateTime? _holdStart;
  DateTime? _lastFaceAt;

  static const _holdDurationMs = 1300;

  @override
  void initState() {
    super.initState();
    _sweep = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat();
    _detector = FaceDetector(
      options: FaceDetectorOptions(
        enableTracking: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
    _setup();
  }

  Future<void> _setup([CameraDescription? preferred]) async {
    try {
      final cameras = await availableCameras();
      final cam = preferred ??
          cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.front,
            orElse: () => cameras.first,
          );
      final controller = CameraController(
        cam,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _camController = controller;
        _controllerDisposed = false;
      });
      await controller.startImageStream(_onFrame);
    } catch (_) {
      if (!mounted) return;
      setState(() => _initFailed = true);
    }
  }

  Future<void> _flipCamera() async {
    if (_camController == null) return;
    final cameras = await availableCameras();
    if (cameras.length < 2) return;
    final currentDirection = _camController!.description.lensDirection;
    final next = cameras.firstWhere((c) => c.lensDirection != currentDirection, orElse: () => cameras.first);
    await _disposeController();
    if (!mounted) return;
    setState(() => _camController = null);
    await _setup(next);
  }

  void _onFrame(CameraImage image) async {
    if (_busy || _handled || _camController == null) return;
    // On Android with ImageFormatGroup.nv21 the camera plugin hands back a single,
    // already-packed NV21 plane. Concatenating "all planes" is only safe when there's
    // exactly one — if the platform ever delivers separate Y/U/V planes instead, blindly
    // joining them produces a corrupted buffer that ML Kit will never find a face in
    // (this was the actual reason detection never succeeded, independent of permissions).
    if (image.planes.length != 1) {
      _busy = false;
      return;
    }
    _busy = true;
    try {
      final camera = _camController!.description;
      final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
          InputImageRotation.rotation0deg;
      final format = InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      final plane = image.planes.first;
      final inputImage = InputImage.fromBytes(
        bytes: plane.bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: rotation,
          format: format,
          bytesPerRow: plane.bytesPerRow,
        ),
      );

      final faces = await _detector.processImage(inputImage);
      if (!mounted) return;

      if (faces.isEmpty) {
        _holdStart = null;
      } else {
        _lastFaceAt = DateTime.now();
        _holdStart ??= DateTime.now();
        final elapsedMs = DateTime.now().difference(_holdStart!).inMilliseconds;
        final progress = (elapsedMs / _holdDurationMs).clamp(0.0, 1.0);

        if (progress >= 1.0 && !_handled) {
          _handled = true;
          await _camController?.stopImageStream();
          setState(() => _confirming = true);
          AppSound.success();
          HapticFeedback.mediumImpact();
          await Future.delayed(const Duration(milliseconds: 900));
          if (!mounted) return;
          BookingsStore.markConfirmed(widget.item);
          Navigator.of(context).pushReplacement(slideUpRoute(VisitConfirmedScreen(item: widget.item)));
        }
      }
    } catch (_) {
      // Ignore individual frame failures; the stream will keep delivering frames.
    } finally {
      _busy = false;
    }
  }

  void _manualConfirm() {
    if (_handled) return;
    _handled = true;
    AppSound.success();
    BookingsStore.markConfirmed(widget.item);
    Navigator.of(context).pushReplacement(slideUpRoute(VisitConfirmedScreen(item: widget.item)));
  }

  void _showInfo() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Yuz orqali tasdiqlash"),
        content: const Text(
          "Xavfsizlik uchun mashg'ulotga aynan siz kelganingizni tekshiramiz. Yuzingizni ramka ichida bir necha soniya qimirlatmasdan ushlab turing. Surat qurilmangizda saqlanmaydi.",
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Tushunarli")),
        ],
      ),
    );
  }

  Future<void> _disposeController() async {
    if (_controllerDisposed) return;
    _controllerDisposed = true;
    await _camController?.dispose();
  }

  @override
  void dispose() {
    if (!_controllerDisposed) {
      _controllerDisposed = true;
      _camController?.dispose();
    }
    _sweep.dispose();
    _detector.close();
    super.dispose();
  }

  Widget _buildCameraLayer() {
    if (_initFailed) return _FaceCameraError(onManualConfirm: _manualConfirm);
    if (_camController == null || !_camController!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    return CoverCameraPreview(
      controller: _camController!,
      // The camera plugin's own front-camera texture is already mirrored on
      // most devices; flipping it again here made the preview move opposite
      // to the user's actual head movement, so we don't mirror manually.
      mirror: false,
    );
  }

  // Proportions measured off the original screenshots: the dashed ring is
  // ~90% of screen width with its center at ~40% of screen height, and the
  // flip button / help link sit at fixed fractions below it.
  static const _ringWidthFraction = 0.90;
  static const _ringCenterY = 0.40;
  static const _headerTopY = 0.133;
  static const _flipCenterY = 0.706;
  static const _helpCenterY = 0.794;
  static const _dashLengthFraction = 0.058;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // LayoutBuilder + StackFit.expand pins every layer to the real body box;
      // relying on MediaQuery/loose Stack sizing previously left the overlays
      // unlaid-out and the camera shrunk to a strip.
      body: LayoutBuilder(builder: (context, constraints) {
        final screen = Size(constraints.maxWidth, constraints.maxHeight);
        final ringSize = screen.width * _ringWidthFraction;
        final dashLength = ringSize * _dashLengthFraction;
        final clearSize = ringSize - dashLength * 2;
        final ringTop = screen.height * _ringCenterY - ringSize / 2;

        return Stack(
          fit: StackFit.expand,
          children: [
          _buildCameraLayer(),
          ScannerBlurMask(
            frameSize: clearSize,
            circle: true,
            centerYFraction: _ringCenterY,
          ),
          Positioned(
            top: ringTop,
            left: (screen.width - ringSize) / 2,
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _sweep,
                builder: (context, _) {
                  // The pale arc only sweeps while a face is actually being
                  // held in frame, matching the original's behaviour.
                  final scanning = _holdStart != null &&
                      _lastFaceAt != null &&
                      DateTime.now().difference(_lastFaceAt!).inMilliseconds < 600;
                  return SizedBox(
                    width: ringSize,
                    height: ringSize,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        DashedProgressRing(
                          size: ringSize,
                          color: ScannerColors.accent,
                          dashCount: 58,
                          dashLength: dashLength,
                          strokeWidth: ringSize * 0.017,
                          allLit: _confirming,
                          highlightAngle: (!_confirming && scanning)
                              ? _sweep.value * 2 * math.pi - math.pi / 2
                              : null,
                        ),
                        if (_confirming)
                          Container(
                            width: clearSize,
                            height: clearSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withValues(alpha: 0.45),
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 62,
                                  height: 62,
                                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                  child: const Icon(Icons.check_rounded, color: ScannerColors.accent, size: 34),
                                ),
                                const SizedBox(height: 20),
                                const Text("Hammasi amalga oshdi",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: screen.height * _headerTopY,
            left: 24,
            right: 24,
            child: const IgnorePointer(
              child: Text(
                "Yuzingizni ramkaga kiriting\nva qimirlamang",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17.5, fontWeight: FontWeight.w700, height: 1.35),
              ),
            ),
          ),
          Positioned(
            top: screen.height * _flipCenterY - 31,
            left: screen.width / 2 - 31,
            child: InkWell(
              borderRadius: BorderRadius.circular(31),
              onTap: _flipCamera,
              child: Container(
                width: 62,
                height: 62,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.cameraswitch_outlined, color: ScannerColors.flipIcon, size: 27),
              ),
            ),
          ),
          Positioned(
            top: screen.height * _helpCenterY - 12,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: _showInfo,
                child: const Text("Yordam kerakmi?",
                    style: TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.w600, fontSize: 16.5)),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 28),
                    onPressed: _showInfo,
                  ),
                ],
              ),
            ),
          ),
          ],
        );
      }),
    );
  }
}

class _FaceCameraError extends StatelessWidget {
  final VoidCallback onManualConfirm;
  const _FaceCameraError({required this.onManualConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.face_retouching_off_rounded, color: Colors.white54, size: 40),
          const SizedBox(height: 10),
          const Text(
            "Kameraga ruxsat berilmagan yoki mavjud emas",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: onManualConfirm,
            child: const Text("Qo'lda tasdiqlash", style: TextStyle(color: ScannerColors.manualConfirm)),
          ),
        ],
      ),
    );
  }
}
