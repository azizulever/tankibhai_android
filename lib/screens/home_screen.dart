import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/models/fuel_entry.dart';
import 'package:mileage_calculator/widgets/stats_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MileageGetxController>(
      init: MileageGetxController(),
      builder: (controller) {
        return HomePageContent(controller: controller);
      },
    );
  }
}

class HomePageContent extends StatelessWidget {
  final MileageGetxController controller;

  const HomePageContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fuel Log'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Select Vehicle:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment<String>(
                        value: 'Bike',
                        icon: Icon(
                          Icons.two_wheeler,
                          color: controller.selectedVehicleType == 'Bike' ? Colors.white : null,
                        ),
                        label: Text(
                          'Bike',
                          style: TextStyle(
                            color: controller.selectedVehicleType == 'Bike' ? Colors.white : null,
                          ),
                        ),
                      ),
                      ButtonSegment<String>(
                        value: 'Car',
                        icon: Icon(
                          Icons.directions_car,
                          color: controller.selectedVehicleType == 'Car' ? Colors.white : null,
                        ),
                        label: Text(
                          'Car',
                          style: TextStyle(
                            color: controller.selectedVehicleType == 'Car' ? Colors.white : null,
                          ),
                        ),
                      ),
                    ],
                    selected: {controller.selectedVehicleType},
                    onSelectionChanged: (Set<String> newSelection) {
                      controller.updateSelectedVehicleType(newSelection.first);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (controller.filteredEntries.isNotEmpty)
            StatsCard(controller: controller),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.selectedVehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler, color: const Color(0xFF0A2463),
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
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            controller.selectedVehicleType == 'Car'
                                ? Icons.directions_car
                                : Icons.two_wheeler,
                            size: 64,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${controller.selectedVehicleType} entries yet.\nAdd your first fueling record.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      itemCount: controller.filteredEntries.length,
                      itemBuilder: (context, index) {
                        final entry = controller.filteredEntries[index];
                        final mileage = controller.calculateMileage(
                          entry,
                          index < controller.filteredEntries.length - 1
                              ? controller.filteredEntries[index + 1]
                              : null,
                        );
                        
                        // Calculate per liter cost
                        final perLiterCost = entry.fuelAmount > 0 
                            ? (entry.fuelCost / entry.fuelAmount).toStringAsFixed(2)
                            : "N/A";

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color(
                                0xFF0A2463,
                              ).withOpacity(0.1),
                              child: Icon(
                                entry.vehicleType == 'Car'
                                    ? Icons.directions_car
                                    : Icons.two_wheeler,
                                color: const Color(0xFF0A2463),
                              ),
                            ),
                            title: Text(
                              'Date: ${DateFormat('MMM dd, yyyy').format(entry.date)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Odometer: ${entry.odometer.toStringAsFixed(1)} km',
                                ),
                                Text(
                                  'Fuel: ${entry.fuelAmount.toStringAsFixed(2)} liters',
                                ),
                                if (mileage != null)
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF0A2463,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Mileage: ${mileage.toStringAsFixed(2)} km/l',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0A2463),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          '- ৳${perLiterCost}/l',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0A2463),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed:
                                      () => _showEditEntryDialog(
                                        context,
                                        entry,
                                        index,
                                      ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => controller.deleteEntry(index),
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEntryDialog(context),
        icon: const Icon(Icons.add),
        label: Text('Add ${controller.selectedVehicleType} Entry'),
      ),
    );
  }

  void _showEditEntryDialog(BuildContext context, FuelEntry entry, int index) {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(entry.date),
    );
    final odometerController = TextEditingController(
      text: entry.odometer.toString(),
    );
    final fuelAmountController = TextEditingController(
      text: entry.fuelAmount.toString(),
    );
    final fuelCostController = TextEditingController(
    text: entry.fuelCost.toString(),
  );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            title: Row(
              children: [
                Icon(
                  entry.vehicleType == 'Car'
                      ? Icons.directions_car
                      : Icons.two_wheeler,
                  color: const Color(0xFF0A2463),
                ),
                const SizedBox(width: 12),
                Text(
                  'Edit ${controller.selectedVehicleType} Entry',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A2463),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date (YYYY-MM-DD)',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF0A2463),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0A2463),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF0A2463),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: entry.date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF0A2463),
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (date != null) {
                        dateController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(date);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: odometerController,
                    decoration: InputDecoration(
                      labelText: 'Odometer Reading (km)',
                      prefixIcon: const Icon(
                        Icons.speed,
                        color: Color(0xFF0A2463),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0A2463),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF0A2463),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fuelAmountController,
                    decoration: InputDecoration(
                      labelText: 'Fuel Added (liters)',
                      prefixIcon: const Icon(
                        Icons.local_gas_station,
                        color: Color(0xFF0A2463),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0A2463),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF0A2463),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                  controller: fuelCostController,
                  decoration: InputDecoration(
                    labelText: 'Total Fuel Cost',
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Color(0xFF0A2463),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF0A2463),
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF0A2463),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text('CANCEL'),
              ),
              FilledButton(
                onPressed: () {
                  try {
                    final date = DateFormat(
                      'yyyy-MM-dd',
                    ).parse(dateController.text);
                    final odometer = double.parse(odometerController.text);
                    final fuelAmount = double.parse(fuelAmountController.text);
                    final fuelCost = double.parse(fuelCostController.text);

                    if (odometer <= 0 || fuelAmount <= 0 || fuelCost < 0) {
                    throw const FormatException(
                      'Values must be greater than zero',
                    );
                  }

                    controller.updateFuelEntry(
                      index,
                      date,
                      odometer,
                      fuelAmount,
                      fuelCost,
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid numbers'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2463),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text('UPDATE'),
              ),
            ],
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actionsAlignment: MainAxisAlignment.spaceBetween,
          ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final odometerController = TextEditingController();
    final fuelAmountController = TextEditingController();
    final fuelCostController = TextEditingController();

    if (controller.filteredEntries.isNotEmpty) {
      odometerController.text =
          (controller.filteredEntries.first.odometer + 100).toStringAsFixed(1);
    }

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            title: Row(
              children: [
                Icon(
                  controller.selectedVehicleType == 'Car'
                      ? Icons.directions_car
                      : Icons.two_wheeler,
                  color: const Color(0xFF0A2463),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Add ${controller.selectedVehicleType} Fueling Record',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0A2463),
                    ),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: dateController,
                    decoration: InputDecoration(
                      labelText: 'Date (YYYY-MM-DD)',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF0A2463),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0A2463),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF0A2463),
                      ),
                    ),
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF0A2463),
                                onPrimary: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );

                      if (date != null) {
                        dateController.text = DateFormat(
                          'yyyy-MM-dd',
                        ).format(date);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: odometerController,
                    decoration: InputDecoration(
                      labelText: 'Odometer Reading (km)',
                      prefixIcon: const Icon(
                        Icons.speed,
                        color: Color(0xFF0A2463),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0A2463),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF0A2463),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: fuelAmountController,
                    decoration: InputDecoration(
                      labelText: 'Fuel Added (liters)',
                      prefixIcon: const Icon(
                        Icons.local_gas_station,
                        color: Color(0xFF0A2463),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF0A2463),
                          width: 2,
                        ),
                      ),
                      floatingLabelStyle: const TextStyle(
                        color: Color(0xFF0A2463),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                                  TextFormField(
                  controller: fuelCostController,
                  decoration: InputDecoration(
                    labelText: 'Total Fuel Cost',
                    prefixIcon: const Icon(
                      Icons.attach_money,
                      color: Color(0xFF0A2463),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF0A2463),
                        width: 2,
                      ),
                    ),
                    floatingLabelStyle: const TextStyle(
                      color: Color(0xFF0A2463),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text('CANCEL'),
              ),
              FilledButton(
                onPressed: () {
                  try {
                    final date = DateFormat(
                      'yyyy-MM-dd',
                    ).parse(dateController.text);
                    final odometer = double.parse(odometerController.text);
                    final fuelAmount = double.parse(fuelAmountController.text);
                    final fuelCost = double.parse(fuelCostController.text);

                    if (odometer <= 0 || fuelAmount <= 0 || fuelCost < 0) {
                    throw const FormatException(
                      'Values must be greater than zero',
                    );
                  }

                    controller.addFuelEntry(
                      date,
                      odometer,
                      fuelAmount,
                      controller.selectedVehicleType,
                      fuelCost,
                    );
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid numbers'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF0A2463),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                child: const Text('SAVE'),
              ),
            ],
            actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            actionsAlignment: MainAxisAlignment.spaceBetween,
          ),
    );
  }
}