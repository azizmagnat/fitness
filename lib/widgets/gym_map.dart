import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

/// Shared OpenStreetMap tile layer configuration. Tiles are fetched over the
/// network; without a connection flutter_map simply renders the empty grid,
/// so every caller stacks it on a dark placeholder colour.
TileLayer osmTileLayer() => TileLayer(
      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      userAgentPackageName: "com.codebusters.onefit",
      maxNativeZoom: 19,
    );

/// Pink teardrop marker matching the pin the original app drops on a gym.
class GymMapPin extends StatelessWidget {
  final double size;
  const GymMapPin({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.location_on, color: const Color(0xFFE0218A), size: size, shadows: const [
      Shadow(color: Colors.black45, blurRadius: 6, offset: Offset(0, 2)),
    ]);
  }
}

/// Small non-interactive map thumbnail used on a gym's detail page.
class GymMapPreview extends StatelessWidget {
  final Gym gym;
  final double height;
  const GymMapPreview({super.key, required this.gym, this.height = 150});

  @override
  Widget build(BuildContext context) {
    if (!gym.hasLocation) {
      return Container(
        height: height,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16)),
        alignment: Alignment.center,
        child: const Icon(Icons.map_rounded, color: AppColors.textSecondary, size: 30),
      );
    }
    final point = LatLng(gym.lat!, gym.lng!);
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFFE8E4DC),
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: point,
                    initialZoom: 15.2,
                    interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                  ),
                  children: [
                    osmTileLayer(),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: point,
                          width: 46,
                          height: 46,
                          alignment: Alignment.topCenter,
                          child: const GymMapPin(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 6,
              bottom: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                color: Colors.white70,
                child: const Text("© OpenStreetMap",
                    style: TextStyle(color: Colors.black87, fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
