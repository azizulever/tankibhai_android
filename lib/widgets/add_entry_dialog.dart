import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';

class AddEntryDialog extends StatefulWidget {
  final MileageGetxController controller;

  const AddEntryDialog({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  State<AddEntryDialog> createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  late TextEditingController dateController;
  late TextEditingController odometerController;
  late TextEditingController fuelAmountController;
  late TextEditingController fuelCostController;

  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    odometerController = TextEditingController();
    fuelAmountController = TextEditingController();
    fuelCostController = TextEditingController();

    if (widget.controller.filteredEntries.isNotEmpty) {
      odometerController.text = (widget.controller.filteredEntries.first.odometer + 100)
          .toStringAsFixed(1);
    }
  }

  @override
  void dispose() {
    dateController.dispose();
    odometerController.dispose();
    fuelAmountController.dispose();
    fuelCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      title: Row(
        children: [
          Icon(
            widget.controller.selectedVehicleType == 'Car'
                ? Icons.directions_car
                : Icons.two_wheeler,
            color: const Color(0xFF0A2463),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Add ${widget.controller.selectedVehicleType} Fueling Record',
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
                  dateController.text = DateFormat('yyyy-MM-dd').format(date);
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
              final date = DateFormat('yyyy-MM-dd').parse(dateController.text);
              final odometer = double.parse(odometerController.text);
              final fuelAmount = double.parse(fuelAmountController.text);
              final fuelCost = double.parse(fuelCostController.text);

              if (odometer <= 0 || fuelAmount <= 0 || fuelCost < 0) {
                throw const FormatException('Values must be greater than zero');
              }

              widget.controller.addFuelEntry(
                date,
                odometer,
                fuelAmount,
                widget.controller.selectedVehicleType,
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
    );
  }
}