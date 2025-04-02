import 'dart:core';

class FuelEntry {
  final DateTime date;
  final double odometer;
  final double fuelAmount;
  final String vehicleType;

  FuelEntry({
    required this.date,
    required this.odometer,
    required this.fuelAmount,
    required this.vehicleType,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.millisecondsSinceEpoch,
      'odometer': odometer,
      'fuelAmount': fuelAmount,
      'vehicleType': vehicleType,
    };
  }

  factory FuelEntry.fromJson(Map<String, dynamic> json) {
    return FuelEntry(
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      odometer: json['odometer'],
      fuelAmount: json['fuelAmount'],
      vehicleType: json['vehicleType'],
    );
  }
}