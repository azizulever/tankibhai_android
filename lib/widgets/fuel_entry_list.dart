import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/models/fuel_entry.dart';
import 'package:intl/intl.dart';

class FuelEntryList extends StatelessWidget {
  final List<FuelEntry> entries;
  final MileageGetxController controller;

  const FuelEntryList({
    required this.entries,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        final mileage = controller.calculateMileage(entry,
            index < entries.length - 1 ? entries[index + 1] : null);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0A2463).withOpacity(0.1),
              child: Icon(
                entry.vehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler,
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
                Text('Fuel: ${entry.fuelAmount.toStringAsFixed(2)} liters - ${entry.fuelCost.toStringAsFixed(2)} cost'),
                if (mileage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A2463).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Mileage: ${mileage.toStringAsFixed(2)} km/l',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0A2463),
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _showEditEntryDialog(context, entry, index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => controller.deleteEntry(index),
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
    // The code for showing the edit dialog goes here (as previously provided)
  }
}
