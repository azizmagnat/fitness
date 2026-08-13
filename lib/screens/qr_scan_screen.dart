import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/page_transitions.dart';
import '../widgets/scanner_overlay.dart';
import '../widgets/sound.dart';
import '../state/bookings_store.dart';
import 'face_scan_screen.dart';
import 'settings_detail_screens.dart';
import 'visit_confirmed_screen.dart';

class QrScanScreen extends StatefulWidget {
  final ScheduleItem item;
  const QrScanScreen({super.key, required this.item});

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _handled = false;
  bool _controllerDisposed = false;

  void _onDetect(BarcodeCapture capture) async {
    if (_handled || capture.barcodes.isEmpty) return;
    _handled = true;
    AppSound.success();
    HapticFeedback.mediumImpact();
    // The back camera (QR) must fully release before the front camera (face
    // scan) can acquire the sensor — on many devices only one camera session
    // can be open at a time, and without this await the face scan's
    // CameraController.initialize() hangs forever with no error, leaving a
    // black preview.
    await _disposeController();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(slideRightRoute(FaceScanScreen(item: widget.item)));
  }

  Future<void> _disposeController() async {
    if (_controllerDisposed) return;
    _controllerDisposed = true;
    await _controller.dispose();
  }

  @override
  void dispose() {
    if (!_controllerDisposed) {
      _controllerDisposed = true;
      _controller.dispose();
    }
    super.dispose();
  }

  // Proportions measured off the original screenshots: the frame is ~77% of
  // screen width and its center sits at ~40.6% of screen height (above the
  // middle), with the flip button and help link at fixed fractions below it.
  static const _frameWidthFraction = 0.77;
  static const _frameCenterY = 0.406;
  static const _headerTopY = 0.152;
  static const _flipCenterY = 0.654;
  static const _helpCenterY = 0.733;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // LayoutBuilder + StackFit.expand keeps every layer pinned to the real
      // body box regardless of insets, so nothing collapses or goes unlaid-out.
      body: LayoutBuilder(builder: (context, constraints) {
        final screen = Size(constraints.maxWidth, constraints.maxHeight);
        final frameSize = screen.width * _frameWidthFraction;

        return Stack(
          fit: StackFit.expand,
          children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            fit: BoxFit.cover,
            errorBuilder: (context, error) => _CameraError(
              onManualConfirm: () {
                if (_handled) return;
                _handled = true;
                AppSound.success();
                BookingsStore.markConfirmed(widget.item);
                Navigator.of(context)
                    .pushReplacement(slideUpRoute(VisitConfirmedScreen(item: widget.item)));
              },
            ),
          ),
          ScannerBlurMask(
            frameSize: frameSize,
            borderRadius: 30,
            centerYFraction: _frameCenterY,
          ),
          Positioned(
            top: screen.height * _frameCenterY - frameSize / 2,
            left: (screen.width - frameSize) / 2,
            child: IgnorePointer(
              child: Container(
                width: frameSize,
                height: frameSize,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accentPurple, width: 7),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          Positioned(
            top: screen.height * _headerTopY,
            left: 24,
            right: 24,
            child: const IgnorePointer(
              child: Text(
                "QR kodini skanerlang\nva mashg'ulotni tasdiqlang",
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
              onTap: () => _controller.switchCamera(),
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
                onTap: () => Navigator.of(context).push(slideRightRoute(const SupportScreen())),
                child: const Text("Yordam kerakmi?",
                    style: TextStyle(color: AppColors.accentPurple, fontWeight: FontWeight.w600, fontSize: 16.5)),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 12, 0),
                child: IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white, size: 28),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
          ],
        );
      }),
    );
  }
}

class _CameraError extends StatelessWidget {
  final VoidCallback onManualConfirm;
  const _CameraError({required this.onManualConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.no_photography_rounded, color: Colors.white54, size: 40),
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
