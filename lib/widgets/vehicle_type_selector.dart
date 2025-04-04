import 'package:flutter/material.dart';

class VehicleTypeSelector extends StatelessWidget {
  final String selectedVehicleType;
  final Function(String) onVehicleTypeChanged;

  const VehicleTypeSelector({
    required this.selectedVehicleType,
    required this.onVehicleTypeChanged,
    Key? key,
  }) : super(key: key);

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
                  value: 'Bike',
                  icon: Icon(
                    Icons.two_wheeler,
                    color: selectedVehicleType == 'Bike' ? Colors.white : const Color(0xFF0A2463),
                  ),
                  label: Text(
                    'Bike',
                    style: TextStyle(
                      color: selectedVehicleType == 'Bike' ? Colors.white : const Color(0xFF0A2463),
                    ),
                  ),
                ),
                ButtonSegment<String>(
                  value: 'Car',
                  icon: Icon(
                    Icons.directions_car,
                    color: selectedVehicleType == 'Car' ? Colors.white : const Color(0xFF0A2463),
                  ),
                  label: Text(
                    'Car',
                    style: TextStyle(
                      color: selectedVehicleType == 'Car' ? Colors.white : const Color(0xFF0A2463),
                    ),
                  ),
                ),
              ],
              selected: {selectedVehicleType},
              onSelectionChanged: (Set<String> newSelection) {
                onVehicleTypeChanged(newSelection.first);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(MaterialState.selected)) {
                      return const Color(0xFF0A2463);
                    }
                    return Colors.white;
                  },
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}