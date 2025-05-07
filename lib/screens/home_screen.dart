import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/widgets/add_entry_dialog.dart';
import 'package:mileage_calculator/widgets/empty_history_placeholder.dart';
import 'package:mileage_calculator/widgets/fuel_entry_list.dart';
import 'package:mileage_calculator/widgets/stats_card.dart';
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
              style: TextStyle(fontWeight: FontWeight.w600),
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
              if (controller.filteredEntries.isNotEmpty)
                StatsCard(controller: controller),
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
}
