import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/models/fuel_entry.dart';
import 'package:intl/intl.dart';
import 'package:mileage_calculator/widgets/edit_entry_dialog.dart';

class FuelEntryList extends StatelessWidget {
  final List<FuelEntry> entries;
  final MileageGetxController controller;

  const FuelEntryList({
    required this.entries,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final mileage = controller.calculateMileage(
          entry,
          index < entries.length - 1 ? entries[index + 1] : null,
        );

        // Calculate per liter cost
        final perLiterCost = entry.fuelAmount > 0
            ? (entry.fuelCost / entry.fuelAmount).toStringAsFixed(2)
            : "N/A";

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0A2463).withOpacity(0.1),
              child: Icon(
                entry.vehicleType == 'Car'
                    ? Icons.directions_car
                    : Icons.two_wheeler,
                color: const Color(0xFF0A2463),
              ),
            ),
            title: Text(
              'Date: ${DateFormat('MMM dd, yyyy').format(entry.date)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Odometer: ${entry.odometer.toStringAsFixed(1)} km'),
                Text('Fuel: ${entry.fuelAmount.toStringAsFixed(2)} liters'),
                if (mileage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A2463).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Mileage: ${mileage.toStringAsFixed(1)} km/l',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2463),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Cost: ৳$perLiterCost/l',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0A2463),
                              ),
                            ),
                          ],
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
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditEntryDialog(
                    context,
                    entry,
                    index,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, index),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  void _showEditEntryDialog(BuildContext context, FuelEntry entry, int index) {
    showDialog(
      context: context,
      builder: (context) => EditEntryDialog(
        controller: controller,
        entry: entry,
        index: index,
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.red),
              const SizedBox(width: 12),
              const Text(
                'Confirm Deletion',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to delete this entry? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                controller.deleteEntry(index);
                Navigator.of(context).pop();
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              child: const Text('DELETE'),
            ),
          ],
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          actionsAlignment: MainAxisAlignment.spaceBetween,
        );
      },
    );
  }
}