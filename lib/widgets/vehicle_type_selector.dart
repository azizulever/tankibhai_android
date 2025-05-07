import 'package:flutter/material.dart';

class VehicleTypeSelector extends StatelessWidget {
  final String selectedVehicleType;
  final Function(String) onVehicleTypeChanged;

  const VehicleTypeSelector({
    Key? key,
    required this.selectedVehicleType,
    required this.onVehicleTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildVehicleButton(context, 'Bike', Icons.two_wheeler),
              _buildVehicleButton(context, 'Car', Icons.directions_car),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleButton(BuildContext context, String type, IconData icon) {
    final isSelected = selectedVehicleType == type;

    return GestureDetector(
      onTap: () => onVehicleTypeChanged(type),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Colors.grey[100]!,
                        // blurRadius: 1,
                        // offset: const Offset(0, 1),
                      ),
                    ]
                    : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.black : Colors.black,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.black,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
