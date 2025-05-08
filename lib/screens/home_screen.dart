import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:mileage_calculator/widgets/add_entry_dialog.dart';
import 'package:mileage_calculator/widgets/empty_history_placeholder.dart';
import 'package:mileage_calculator/widgets/fuel_entry_list.dart';
import 'package:mileage_calculator/widgets/vehicle_type_selector.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MileageGetxController>(
      init: MileageGetxController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'TankiBhai - Fuel Tracker',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          ),
          body: Column(
            children: [
              VehicleTypeSelector(
                selectedVehicleType: controller.selectedVehicleType,
                onVehicleTypeChanged: controller.updateSelectedVehicleType,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: Colors.grey[300], thickness: 1),
              ),

              // Add Bike Overview Section with GridView
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        '${controller.selectedVehicleType} Overview',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio:
                              constraints.maxWidth > 600 ? 2.0 : 1.6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            // Average Mileage Card (Blue)
                            _buildStatCard(
                              context: context,
                              title: 'Avg. Mileage',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.averageMileage
                                          .toStringAsFixed(1),
                              unit: 'KM/L',
                              icon: Icons.speed,
                              isBlue: true,
                            ),

                            // Latest Mileage Card (White)
                            _buildStatCard(
                              context: context,
                              title: 'Latest Mileage',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.lastMileage.toStringAsFixed(
                                        1,
                                      ),
                              unit: 'KM/L',
                              icon: Icons.speed,
                              isBlue: false,
                            ),

                            // Average Fuel Cost Card (White)
                            _buildStatCard(
                              context: context,
                              title: 'Avg. Fuel Cost',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.averageFuelPrice
                                          .toStringAsFixed(1),
                              unit: 'TK/L',
                              icon: Icons.currency_exchange,
                              isBlue: false,
                            ),

                            // Latest Fuel Cost Card (Blue)
                            _buildStatCard(
                              context: context,
                              title: 'Latest Fuel Cost',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.lastFuelPrice
                                          .toStringAsFixed(1),
                              unit: 'TK/L',
                              icon: Icons.currency_exchange,
                              isBlue: true,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: Colors.grey[300], thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      controller.selectedVehicleType == 'Car'
                          ? Icons.directions_car
                          : Icons.two_wheeler,
                      color: const Color(0xFF0A2463),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${controller.selectedVehicleType} Fueling History',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child:
                    controller.filteredEntries.isEmpty
                        ? EmptyHistoryPlaceholder(
                          vehicleType: controller.selectedVehicleType,
                        )
                        : FuelEntryList(
                          entries: controller.filteredEntries,
                          controller: controller,
                        ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (context) => AddEntryDialog(controller: controller),
                ),
            icon: const Icon(Icons.add),
            label: Text('Add ${controller.selectedVehicleType} Entry'),
          ),
        );
      },
    );
  }

  // Helper method to build stat cards
  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required bool isBlue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isBlue ? primaryColor : backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isBlue ? Colors.white : Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isBlue ? primaryColor : backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isBlue ? Colors.blue.shade700 : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isBlue ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: isBlue ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: isBlue ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
