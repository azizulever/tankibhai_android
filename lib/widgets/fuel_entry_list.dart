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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: EdgeInsets.symmetric(
            horizontal: screenSize.width > 600 ? screenSize.width * 0.15 : 24,
            vertical: screenSize.height > 800 ? 40 : 24,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Warning header with gradient for more visual appeal
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.red,
                        Color(0xFFE53935),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x40E53935),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: isSmallScreen ? 20 : 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Confirm Deletion',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Warning message with responsive padding
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    isSmallScreen ? 16 : 20,
                    20,
                    isSmallScreen ? 12 : 16,
                  ),
                  child: Text(
                    'Are you sure you want to delete this entry? This action cannot be undone.',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      height: 1.4,
                      color: Colors.black87,
                    ),
                  ),
                ),
                
                // Action buttons with responsive sizing
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    isSmallScreen ? 12 : 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                        child: const Text('CANCEL'),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      FilledButton(
                        onPressed: () {
                          controller.deleteEntry(index);
                          Navigator.of(context).pop();
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: isSmallScreen ? 13 : 14,
                          ),
                        ),
                        child: const Text('DELETE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}