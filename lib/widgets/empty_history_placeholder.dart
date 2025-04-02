import 'package:flutter/material.dart';

class EmptyHistoryPlaceholder extends StatelessWidget {
  final String vehicleType;

  const EmptyHistoryPlaceholder({required this.vehicleType});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            vehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No $vehicleType entries yet.\nAdd your first fueling record.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
