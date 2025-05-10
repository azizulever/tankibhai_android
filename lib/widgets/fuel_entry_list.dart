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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), // Reduced padding
      itemCount: filteredEntries.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey,
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

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6), // Reduced padding
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular icon with blue motorcycle - smaller margins
              Container(
                margin: const EdgeInsets.only(right: 10, top: 4), // Reduced margin
                width: 42, // Slightly smaller
                height: 42,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                ),
                child: Center(
                  child: Icon(
                    entry.vehicleType == 'Car'
                        ? Icons.directions_car_rounded
                        : Icons.two_wheeler_rounded,
                    color: Colors.blue, // Use theme color
                    size: 22, // Slightly smaller
                  ),
                ),
              ),
              
              // Middle section - more compact
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date - more compact
                    Text(
                      DateFormat('MMM d, yyyy').format(entry.date),
                      style: const TextStyle(
                        fontSize: 16, // Smaller font
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2), // Reduced spacing
                    
                    // Odometer reading - more compact
                    Text(
                      'Odometer: ${entry.odometer.toStringAsFixed(1)} KM',
                      style: TextStyle(
                        fontSize: 13, // Smaller font
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 1), // Reduced spacing
                    
                    // Fuel amount - more compact
                    Text(
                      'Fuel: ${entry.fuelAmount.toStringAsFixed(2)} Liters',
                      style: TextStyle(
                        fontSize: 13, // Smaller font
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right side - more compact
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // For the first entry, show "Initial Data" instead of mileage
                  isFirst 
                    ? const Text(
                        'Initial Data',
                        style: TextStyle(
                          fontSize: 14, // Smaller font
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )
                    : mileage != null
                      ? Text(
                          '${mileage.toStringAsFixed(1)} KM/L',
                          style: const TextStyle(
                            fontSize: 14, // Smaller font
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Use theme color
                          ),
                        )
                      : const SizedBox(),
                      
                  // Fuel price - more compact
                  if (!isFirst && perLiterCost != "N/A")
                    Text(
                      '৳$perLiterCost/L',
                      style: TextStyle(
                        fontSize: 13, // Smaller font
                        fontWeight: FontWeight.w600,
                        color: Colors.green[600],
                      ),
                    ),
                    
                  // Edit and delete buttons - more compact
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0), // Reduced padding
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 6), // Reduced margin
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1), // Use theme color
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.3), // Use theme color
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () => _showEditEntryDialog(
                              context,
                              entry,
                              originalIndex,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6, // Reduced padding
                                vertical: 3, // Reduced padding
                              ),
                              child: const Icon(
                                Icons.edit_rounded,
                                color: Colors.blue, // Use theme color
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () => _showDeleteConfirmation(context, originalIndex),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6, // Reduced padding
                                vertical: 3, // Reduced padding
                              ),
                              child: Icon(
                                Icons.delete_rounded,
                                color: Colors.red,
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with red warning icon
                Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Confirm Deletion',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Simple message text in gray
                const Text(
                  'Are you sure you want to delete this entry? This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                // Button row with blue cancel and red delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue,
                      ),
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    TextButton(
                      onPressed: () {
                        controller.deleteEntry(index);
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}