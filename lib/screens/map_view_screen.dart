import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../state/visits_store.dart';
import '../widgets/app_actions.dart';
import '../widgets/gym_map.dart';
import '../widgets/page_transitions.dart';
import 'category_results_screen.dart';
import 'gym_detail_screen.dart';
import 'time_slot_screen.dart';

/// Real, pannable OpenStreetMap of every gym in the catalogue. Tapping a pin
/// opens a preview card; tapping the card opens the gym.
class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final MapController _map = MapController();
  Gym? _selected;
  String? _typeFilter;

  static final _tashkent = LatLng(41.2995, 69.2401);

  List<Gym> get _gyms {
    final all = MockData.allGyms.where((g) => g.hasLocation).toList();
    if (_typeFilter == null) return all;
    return all.where((g) => g.tags.contains(_typeFilter)).toList();
  }

  void _zoom(double delta) {
    final camera = _map.camera;
    _map.move(camera.center, (camera.zoom + delta).clamp(3.0, 18.0));
  }

  void _fitAll() {
    final gyms = _gyms;
    if (gyms.isEmpty) return;
    var minLat = gyms.first.lat!, maxLat = gyms.first.lat!;
    var minLng = gyms.first.lng!, maxLng = gyms.first.lng!;
    for (final g in gyms) {
      minLat = g.lat! < minLat ? g.lat! : minLat;
      maxLat = g.lat! > maxLat ? g.lat! : maxLat;
      minLng = g.lng! < minLng ? g.lng! : minLng;
      maxLng = g.lng! > maxLng ? g.lng! : maxLng;
    }
    _map.fitCamera(
      CameraFit.bounds(
        bounds: LatLngBounds(LatLng(minLat, minLng), LatLng(maxLat, maxLng)),
        padding: const EdgeInsets.fromLTRB(60, 120, 60, 200),
      ),
    );
  }

  Future<void> _pickType() async {
    final types = <String>{for (final g in MockData.allGyms) ...g.tags}.toList()..sort();
    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: Text("Mashg'ulot turi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
            ),
            ListTile(
              title: const Text("Barchasi"),
              trailing: _typeFilter == null ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
              onTap: () => Navigator.of(ctx).pop("__all__"),
            ),
            for (final t in types)
              ListTile(
                title: Text(t),
                trailing: _typeFilter == t ? const Icon(Icons.check_rounded, color: AppColors.primary) : null,
                onTap: () => Navigator.of(ctx).pop(t),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    setState(() {
      _typeFilter = picked == "__all__" ? null : picked;
      _selected = null;
    });
    _fitAll();
  }

  @override
  Widget build(BuildContext context) {
    final gyms = _gyms;
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_typeFilter ?? "Barcha mashg'ulotlar",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        Text("${gyms.length} zal xaritada",
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.my_location_rounded),
                    tooltip: "Hammasini ko'rsatish",
                    onPressed: _fitAll,
                  ),
                  IconButton(icon: const Icon(Icons.tune_rounded), onPressed: _pickType),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: _typeFilter ?? "Mashg'ulot turi",
                    active: _typeFilter != null,
                    onTap: _pickType,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(label: "Hammasini ko'rish", onTap: _fitAll),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: const Color(0xFFE8E4DC),
                      child: FlutterMap(
                        mapController: _map,
                        options: MapOptions(
                          initialCenter: _tashkent,
                          initialZoom: 11.5,
                          onTap: (_, __) => setState(() => _selected = null),
                        ),
                        children: [
                          osmTileLayer(),
                          MarkerLayer(
                            markers: [
                              for (final gym in gyms)
                                Marker(
                                  point: LatLng(gym.lat!, gym.lng!),
                                  width: 130,
                                  height: 62,
                                  alignment: Alignment.topCenter,
                                  child: _MapMarker(
                                    gym: gym,
                                    selected: _selected?.name == gym.name,
                                    onTap: () {
                                      setState(() => _selected = gym);
                                      _map.move(LatLng(gym.lat!, gym.lng!), 15);
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12,
                    bottom: _selected != null ? 190 : 90,
                    child: Column(
                      children: [
                        _RoundIconButton(icon: Icons.add, onTap: () => _zoom(1)),
                        const SizedBox(height: 8),
                        _RoundIconButton(icon: Icons.remove, onTap: () => _zoom(-1)),
                      ],
                    ),
                  ),
                  if (_selected != null)
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 18,
                      child: _GymPreviewCard(
                        gym: _selected!,
                        onClose: () => setState(() => _selected = null),
                      ),
                    )
                  else
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 20,
                      child: Center(
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.of(context).push(slideRightRoute(
                            CategoryResultsScreen(category: _typeFilter ?? "Barcha mashg'ulotlar", gyms: gyms),
                          )),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          icon: const Icon(Icons.list_rounded, size: 18),
                          label: const Text("Ro'yxat"),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  final Gym gym;
  final bool selected;
  final VoidCallback onTap;
  const _MapMarker({required this.gym, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GymMapPin(size: selected ? 48 : 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(gym.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _GymPreviewCard extends StatelessWidget {
  final Gym gym;
  final VoidCallback onClose;
  const _GymPreviewCard({required this.gym, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => Navigator.of(context).push(slideRightRoute(GymDetailScreen(gym: gym))),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (gym.photoAssets.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(gym.photoAssets.first, width: 56, height: 56, fit: BoxFit.cover),
                    ),
                  if (gym.photoAssets.isNotEmpty) const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(gym.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(gym.rating.toStringAsFixed(1),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13.5)),
                            const SizedBox(width: 3),
                            const Icon(Icons.star, color: AppColors.accentGreen, size: 14),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(gym.address,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ValueListenableBuilder<Map<String, int>>(
                          valueListenable: VisitsStore.remaining,
                          builder: (context, _, __) => Text(
                            "${VisitsStore.remainingFor(gym.name)} tashrif qoldi",
                            style: const TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.textSecondary),
                    onPressed: onClose,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => openMapsDirections(context, "${gym.name}, ${gym.address}"),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.divider),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: const Icon(Icons.navigation_outlined, size: 16),
                      label: const Text("Marshrut", style: TextStyle(fontSize: 13)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(slideRightRoute(TimeSlotScreen(gym: gym))),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text("Jadval", style: TextStyle(fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _FilterChip({required this.label, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.primary : AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: const TextStyle(fontSize: 12.5)),
            const Icon(Icons.expand_more_rounded, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1C222C),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 42, height: 42, child: Icon(icon, color: Colors.white, size: 20)),
      ),
    );
  }
}
