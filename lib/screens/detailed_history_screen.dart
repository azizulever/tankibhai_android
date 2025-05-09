import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:mileage_calculator/widgets/tabbed_fuel_history.dart';

class DetailedHistoryScreen extends StatelessWidget {
  const DetailedHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MileageGetxController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${controller.selectedVehicleType} Fueling Details',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            elevation: 2,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              // Statistics section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fueling Statistics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(
                          title: 'Total Fuel',
                          value: '${controller.getTotalFuel().toStringAsFixed(2)} L',
                          icon: Icons.local_gas_station_rounded,
                        ),
                        _buildStatItem(
                          title: 'Total Cost',
                          value: '৳${controller.getTotalCost().toStringAsFixed(2)}',
                          icon: Icons.payments_rounded,
                        ),
                        _buildStatItem(
                          title: 'Total Distance',
                          value: '${controller.getTotalDistance().toStringAsFixed(1)} km',
                          icon: Icons.map_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Tabbed history view
              Expanded(
                child: controller.filteredEntries.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.selectedVehicleType == 'Car'
                                  ? Icons.directions_car_rounded
                                  : Icons.motorcycle_rounded,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No ${controller.selectedVehicleType} Records Found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Add some entries to see detailed statistics',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : TabbedFuelHistory(
                        entries: controller.filteredEntries,
                        controller: controller,
                        vehicleType: controller.selectedVehicleType,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
