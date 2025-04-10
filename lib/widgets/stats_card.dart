import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';

class StatsCard extends StatelessWidget {
  final MileageGetxController controller;

  const StatsCard({super.key, required this.controller});

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF0A2463), size: 23),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width to adjust UI based on device size
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    
    return Card(
      margin: EdgeInsets.all(isSmallScreen ? 8 : 16),
      elevation: 3,
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
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
                  size: isSmallScreen ? 16 : 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${controller.selectedVehicleType} Statistics',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 18, 
                      fontWeight: FontWeight.bold
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A2463).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                physics: const BouncingScrollPhysics(),
                child: Row(
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
                    _buildStatItem(
                      'Total Distance',
                      controller.calculateTotalDistance() != null
                          ? '${controller.calculateTotalDistance()!.toStringAsFixed(2)} km'
                          : 'N/A',
                      Icons.map,
                    ),
                    _buildStatItem(
                      'Total Fuel',
                      controller.calculateTotalFuel() != null
                          ? '${controller.calculateTotalFuel()!.toStringAsFixed(2)} L'
                          : 'N/A',
                      Icons.local_gas_station,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Center(
                child: Text(
                  'Scroll for more stats →',
                  style: TextStyle(
                    fontSize: 11, 
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}