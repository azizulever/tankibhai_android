import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';

class StatsCard extends StatelessWidget {
  final MileageGetxController controller;

  const StatsCard({super.key, required this.controller});

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF0A2463).withOpacity(0.05),
            const Color(0xFF0A2463).withOpacity(0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0A2463), size: 18),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF0A2463),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A2463),
            ),
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
      margin: EdgeInsets.all(isSmallScreen ? 6 : 12),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A2463).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    controller.selectedVehicleType == 'Car'
                        ? Icons.analytics
                        : Icons.bar_chart,
                    color: const Color(0xFF0A2463),
                    size: isSmallScreen ? 14 : 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '${controller.selectedVehicleType} Performance',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 15 : 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A2463),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Divider(
              height: 20,
              color: const Color(0xFF0A2463).withOpacity(0.2),
              thickness: 0.8,
            ),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: screenWidth > 600 ? 3 : 2,
              childAspectRatio: 2.4,
              crossAxisSpacing: 6,
              mainAxisSpacing: 10,
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
          ],
        ),
      ),
    );
  }
}
