import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fuel_entry.dart';

class MileageGetxController extends GetxController {
  String _selectedVehicleType = 'Car';
  final List<String> _vehicleTypes = ['Car', 'Bike'];
  final List<FuelEntry> _fuelEntries = [];
  final int _maxHistoryEntries = 10;

  String get selectedVehicleType => _selectedVehicleType;
  List<String> get vehicleTypes => _vehicleTypes;
  List<FuelEntry> get fuelEntries => _fuelEntries;
  int get maxHistoryEntries => _maxHistoryEntries;

  MileageGetxController() {
    _loadSavedVehicleType();
    _loadFuelEntries();
  }

  Future<void> _loadSavedVehicleType() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedVehicleType = prefs.getString('selected_vehicle_type') ?? 'Car';
    update();
  }

  Future<void> _saveVehicleType(String vehicleType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_vehicle_type', vehicleType);
  }

  Future<void> _loadFuelEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('fuel_entries') ?? [];

    _fuelEntries.clear();
    for (var entryJson in entriesJson) {
      _fuelEntries.add(FuelEntry.fromJson(json.decode(entryJson)));
    }
    _fuelEntries.sort((a, b) => b.date.compareTo(a.date));
    update();
  }

  Future<void> _saveFuelEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson =
        _fuelEntries.map((entry) => json.encode(entry.toJson())).toList();

    await prefs.setStringList('fuel_entries', entriesJson);
  }

  List<FuelEntry> get filteredEntries {
    return _fuelEntries
        .where((entry) => entry.vehicleType == _selectedVehicleType)
        .toList();
  }

  void updateSelectedVehicleType(String newSelection) {
    _selectedVehicleType = newSelection;
    _saveVehicleType(_selectedVehicleType);
    update();
  }

  void addFuelEntry(
      DateTime date, double odometer, double fuelAmount, String vehicleType, double fuelCost) {
    _fuelEntries.insert(
      0,
      FuelEntry(
        date: date,
        odometer: odometer,
        fuelAmount: fuelAmount,
        vehicleType: vehicleType,
        fuelCost: fuelCost,
      ),
    );

    _fuelEntries.sort((a, b) => b.date.compareTo(a.date));

    final carEntries = _fuelEntries.where((e) => e.vehicleType == 'Car').toList();
    final bikeEntries =
        _fuelEntries.where((e) => e.vehicleType == 'Bike').toList();

    if (carEntries.length > _maxHistoryEntries) {
      carEntries.sublist(_maxHistoryEntries).forEach((e) {
        _fuelEntries.remove(e);
      });
    }

    if (bikeEntries.length > _maxHistoryEntries) {
      bikeEntries.sublist(_maxHistoryEntries).forEach((e) {
        _fuelEntries.remove(e);
      });
    }

    _saveFuelEntries();
    update();
  }

  void updateFuelEntry(
      int index, DateTime date, double odometer, double fuelAmount, double fuelCost) {
    final vehicleType = filteredEntries[index].vehicleType;
    final originalIndex = _fuelEntries.indexOf(filteredEntries[index]);

    if (originalIndex >= 0) {
      _fuelEntries[originalIndex] = FuelEntry(
        date: date,
        odometer: odometer,
        fuelAmount: fuelAmount,
        vehicleType: vehicleType,
        fuelCost: fuelCost,
      );

      _fuelEntries.sort((a, b) => b.date.compareTo(a.date));

      _saveFuelEntries();
      update();
    }
  }

  void deleteEntry(int index) {
    final originalIndex = _fuelEntries.indexOf(filteredEntries[index]);

    if (originalIndex >= 0) {
      _fuelEntries.removeAt(originalIndex);
      _saveFuelEntries();
      update();
    }
  }

  double? calculateMileage(FuelEntry currentEntry, FuelEntry? previousEntry) {
    if (previousEntry == null) return null;

    final distance = currentEntry.odometer - previousEntry.odometer;
    if (distance <= 0 || previousEntry.fuelAmount <= 0) return null;

    return distance / previousEntry.fuelAmount;
  }

  double? calculateAverageMileage() {
    double? avgMileage;
    double totalFuel = 0;
    double totalDistance = 0;

    if (filteredEntries.length >= 2) {
      double totalFuelUsed = 0;

      for (int i = 0; i < filteredEntries.length - 1; i++) {
        final currentEntry = filteredEntries[i];
        final previousEntry = filteredEntries[i + 1];

        final distance = currentEntry.odometer - previousEntry.odometer;
        if (distance > 0) {
          totalDistance += distance;
          totalFuelUsed += previousEntry.fuelAmount;
        }
      }

      if (totalFuelUsed > 0) {
        avgMileage = totalDistance / totalFuelUsed;
      }

      for (var entry in filteredEntries) {
        totalFuel += entry.fuelAmount;
      }
    }
    return avgMileage;
  }

  double? calculateLatestMileage() {
    double? latestMileage;
    if (filteredEntries.length >= 2) {
      final currentEntry = filteredEntries[0];
      final previousEntry = filteredEntries[1];

      final distance = currentEntry.odometer - previousEntry.odometer;
      if (distance > 0) {
        latestMileage = distance / previousEntry.fuelAmount;
      }
    }
    return latestMileage;
  }

  double calculateTotalDistance() {
    double totalDistance = 0;

    if (filteredEntries.length >= 2) {
      for (int i = 0; i < filteredEntries.length - 1; i++) {
        final currentEntry = filteredEntries[i];
        final previousEntry = filteredEntries[i + 1];

        final distance = currentEntry.odometer - previousEntry.odometer;
        if (distance > 0) {
          totalDistance += distance;
        }
      }
    }
    return totalDistance;
  }

  double calculateTotalFuel() {
    double totalFuel = 0;
    for (var entry in filteredEntries) {
      totalFuel += entry.fuelAmount;
    }
    return totalFuel;
  }

  double? calculateAverageFuelCost() {
  double? avgCost;
  double totalCost = 0;
  double totalFuel = 0;

  if (filteredEntries.isNotEmpty) {
    for (var entry in filteredEntries) {
      totalCost += entry.fuelCost;
      totalFuel += entry.fuelAmount;
    }
    
    if (totalFuel > 0) {
      avgCost = totalCost / totalFuel;
    }
  }
  return avgCost;
}

double? calculateLatestFuelCost() {
  if (filteredEntries.isNotEmpty) {
    final latestEntry = filteredEntries[0];
    if (latestEntry.fuelAmount > 0) {
      return latestEntry.fuelCost / latestEntry.fuelAmount;
    }
  }
  return null;
}
}