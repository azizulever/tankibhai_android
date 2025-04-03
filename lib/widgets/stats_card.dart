import 'package:flutter/material.dart';
import '../controllers/mileage_controller.dart';

class StatsCard extends StatelessWidget {
  final MileageGetxController controller; // Change here

  const StatsCard({super.key, required this.controller});

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0A2463)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  controller.selectedVehicleType == 'Car'
                      ? Icons.analytics
                      : Icons.bar_chart,
                  color: const Color(0xFF0A2463),
                ),
                const SizedBox(width: 8),
                Text(
                  '${controller.selectedVehicleType} Statistics',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2463).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Avg. Mileage',
                    controller.calculateAverageMileage() != null
                        ? '${controller.calculateAverageMileage()!.toStringAsFixed(2)} km/l'
                        : 'N/A',
                    Icons.speed,
                  ),
                  _buildStatItem(
                    'Latest Mileage',
                    controller.calculateLatestMileage() != null
                        ? '${controller.calculateLatestMileage()!.toStringAsFixed(2)} km/l'
                        : 'N/A',
                    Icons.trending_up,
                  ),
                  _buildStatItem(
                    'Total Distance',
                    '${controller.calculateTotalDistance().toStringAsFixed(1)} km',
                    Icons.map,
                  ),
                  _buildStatItem(
                    'Total Fuel',
                    '${controller.calculateTotalFuel().toStringAsFixed(2)} L',
                    Icons.local_gas_station,
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