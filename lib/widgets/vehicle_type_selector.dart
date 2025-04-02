import 'package:flutter/material.dart';

class VehicleTypeSelector extends StatelessWidget {
  final String selectedVehicleType;
  final Function(String) onVehicleTypeChanged;

  const VehicleTypeSelector({
    required this.selectedVehicleType,
    required this.onVehicleTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                  value: 'Car',
                  icon: const Icon(Icons.directions_car),
                  label: const Text('Car'),
                ),
                ButtonSegment<String>(
                  value: 'Bike',
                  icon: const Icon(Icons.two_wheeler),
                  label: const Text('Bike'),
                ),
              ],
              selected: {selectedVehicleType},
              onSelectionChanged: (Set<String> newSelection) {
                onVehicleTypeChanged(newSelection.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}
