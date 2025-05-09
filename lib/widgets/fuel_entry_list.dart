import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/models/fuel_entry.dart';
import 'package:intl/intl.dart';
import 'package:mileage_calculator/widgets/edit_entry_dialog.dart';

class FuelEntryList extends StatelessWidget {
  final List<FuelEntry> entries;
  final MileageGetxController controller;
  final String listType; // "all", "recent", or "best"

  const FuelEntryList({
    required this.entries,
    required this.controller,
    this.listType = "all",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter entries based on listType
    List<FuelEntry> filteredEntries = entries;
    if (listType == "recent") {
      // Show only the most recent 5 entries
      filteredEntries = entries.length > 5 ? entries.sublist(0, 5) : entries;
    } else if (listType == "best") {
      // Sort by best mileage and take top 5
      filteredEntries = List<FuelEntry>.from(entries);
      filteredEntries.sort((a, b) {
        final mileageA = controller.calculateMileage(a, null) ?? 0;
        final mileageB = controller.calculateMileage(b, null) ?? 0;
        return mileageB.compareTo(mileageA); // Descending order
      });
      filteredEntries = filteredEntries.length > 5 ? filteredEntries.sublist(0, 5) : filteredEntries;
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: filteredEntries.length,
      separatorBuilder: (context, index) => Divider(
        color: Colors.grey[300],
        height: 1,
        indent: 70, 
        endIndent: 16,
      ),
      itemBuilder: (context, index) {
        final entry = filteredEntries[index];
        
        // Find the original index for correct calculations
        final originalIndex = entries.indexOf(entry);
        final isFirst = originalIndex == entries.length - 1;
        final mileage = controller.calculateMileage(
          entry,
          originalIndex < entries.length - 1 ? entries[originalIndex + 1] : null,
        );

        // Calculate per liter cost
        final perLiterCost = entry.fuelAmount > 0
            ? (entry.fuelCost / entry.fuelAmount).toStringAsFixed(2)
            : "N/A";

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle icon in circle - modernized
              Container(
                margin: const EdgeInsets.only(right: 18.0, top: 2.0),
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0A2463).withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    entry.vehicleType == 'Car'
                        ? Icons.directions_car_rounded // Rounded icons for modern look
                        : Icons.motorcycle_rounded,
                    color: const Color(0xFF0A2463),
                    size: 26,
                  ),
                ),
              ),
              
              // Middle section with date and odometer/fuel info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date with better spacing
                    Text(
                      DateFormat('MMM dd, yyyy').format(entry.date),
                      style: const TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 10),
                    
                    // Odometer reading
                    Row(
                      children: [
                        Icon(
                          Icons.speed_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Odometer: ${entry.odometer.toStringAsFixed(1)} km',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    
                    // Fuel amount
                    Row(
                      children: [
                        Icon(
                          Icons.local_gas_station_rounded,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Fuel: ${entry.fuelAmount.toStringAsFixed(2)} liters',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Right section with mileage and fuel price
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // For the first entry, show "Initial Data" instead of mileage
                    isFirst 
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, 
                            vertical: 4
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Initial Data',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A2463),
                            ),
                          ),
                        )
                      : mileage != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10, 
                                vertical: 4
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0A2463).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.speed_rounded,
                                    size: 14,
                                    color: Color(0xFF0A2463),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${mileage.toStringAsFixed(1)} km/l',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A2463),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox(),
                        
                    // Fuel price with better styling
                    if (!isFirst && perLiterCost != "N/A")
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, right: 2.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.payments_rounded,
                              size: 14,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '৳$perLiterCost/l',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    // Edit and delete buttons with modern look
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        children: [
                          Material(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => _showEditEntryDialog(
                                context,
                                entry,
                                originalIndex,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.edit_rounded,
                                  color: Colors.blue[700],
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Material(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => _showDeleteConfirmation(context, originalIndex),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.delete_rounded,
                                  color: Colors.red[700],
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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