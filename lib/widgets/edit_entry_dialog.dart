import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/models/fuel_entry.dart';
import 'package:mileage_calculator/utils/theme.dart';

class EditEntryDialog extends StatefulWidget {
  final MileageGetxController controller;
  final FuelEntry entry;
  final int index;

  const EditEntryDialog({
    Key? key,
    required this.controller,
    required this.entry,
    required this.index,
  }) : super(key: key);

  @override
  State<EditEntryDialog> createState() => _EditEntryDialogState();
}

class _EditEntryDialogState extends State<EditEntryDialog> {
  late final TextEditingController dateController;
  late final TextEditingController odometerController;
  late final TextEditingController fuelAmountController;
  late final TextEditingController fuelCostController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with current entry values
    dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.entry.date));
    odometerController = TextEditingController(text: widget.entry.odometer.toString());
    fuelAmountController = TextEditingController(text: widget.entry.fuelAmount.toString());
    fuelCostController = TextEditingController(text: widget.entry.fuelCost.toString());
  }

  @override
  void dispose() {
    dateController.dispose();
    odometerController.dispose();
    fuelAmountController.dispose();
    fuelCostController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.entry.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 3650)), // Allow future dates
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width > 600 ? screenSize.width * 0.15 : 20,
        vertical: screenSize.height > 800 ? 40 : 24,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 450,
          maxHeight: screenSize.height * 0.85,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with gradient for more visual appeal
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor,
                        primaryColor.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.25),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: isSmallScreen ? 12 : 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              widget.entry.vehicleType == 'Car'
                                  ? Icons.directions_car_rounded
                                  : Icons.two_wheeler_rounded,
                              color: Colors.white,
                              size: isSmallScreen ? 20 : 24,
                            ),
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                'Edit ${widget.entry.vehicleType} Fueling Record',
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 16 : 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.close_rounded,
                              color: Colors.white,
                              size: isSmallScreen ? 18 : 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 12 : 16),
                
                // Input fields with responsive sizing
                _buildInputField(
                  label: 'Date',
                  hint: 'YYYY-MM-DD',
                  controller: dateController,
                  readOnly: true,
                  isSmallScreen: isSmallScreen,
                  onTap: () => _selectDate(context),
                  suffixIcon: const Icon(Icons.calendar_today_rounded, color: primaryColor, size: 20),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a date';
                    }
                    return null;
                  },
                ),
                
                _buildInputField(
                  label: 'Odometer Reading',
                  hint: 'Enter in kilometers',
                  controller: odometerController,
                  isSmallScreen: isSmallScreen,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter odometer reading';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                _buildInputField(
                  label: 'Fuel Added',
                  hint: 'Enter in liters',
                  controller: fuelAmountController,
                  isSmallScreen: isSmallScreen,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fuel amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                _buildInputField(
                  label: 'Total Fuel Cost',
                  hint: 'Enter in taka',
                  controller: fuelCostController,
                  isSmallScreen: isSmallScreen,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter fuel cost';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                
                // Action buttons with responsive sizing
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    isSmallScreen ? 12 : 20,
                    16,
                    isSmallScreen ? 12 : 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                        ),
                        child: const Text('CANCEL'),
                      ),
                      SizedBox(width: isSmallScreen ? 4 : 8),
                      FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.controller.updateFuelEntry(
                              widget.index,
                              DateTime.parse(dateController.text),
                              double.parse(odometerController.text),
                              double.parse(fuelAmountController.text),
                              double.parse(fuelCostController.text),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 12 : 16,
                            vertical: isSmallScreen ? 8 : 12,
                          ),
                        ),
                        child: const Text('UPDATE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isSmallScreen,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isSmallScreen ? 6 : 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.w500,
              color: primaryColor,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            readOnly: readOnly,
            onTap: onTap,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: isSmallScreen ? 13 : 15,
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: isSmallScreen ? 12 : 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              errorStyle: TextStyle(
                fontSize: isSmallScreen ? 10 : 12,
              ),
              suffixIcon: suffixIcon,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
