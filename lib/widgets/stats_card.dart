import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';

class StatsCard extends StatelessWidget {
  final MileageGetxController controller;

  const StatsCard({super.key, required this.controller});

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0A2463), size: 23,),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
                    'Avg. Fuel Cost',
                    controller.calculateAverageFuelCost() != null
                        ? '${controller.calculateAverageFuelCost()!.toStringAsFixed(2)}/l'
                        : 'N/A',
                    Icons.attach_money,
                  ),
                  _buildStatItem(
                    'Latest Fuel Cost',
                    controller.calculateLatestFuelCost() != null
                        ? '${controller.calculateLatestFuelCost()!.toStringAsFixed(2)}/l'
                        : 'N/A',
                    Icons.trending_flat,
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