import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MileageCalculatorApp());
}

class MileageCalculatorApp extends StatelessWidget {
  const MileageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mileage Calculator',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A2463), // Deep blue
          brightness: Brightness.light,
          primary: const Color(0xFF0A2463), // Deep blue
          onPrimary: Colors.white,
          secondary: const Color(0xFF153B83), // Lighter blue
          onSecondary: Colors.white,
          background: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A2463),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFF0A2463);
                }
                return Colors.white;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.white;
                }
                return const Color(0xFF0A2463);
              },
            ),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF153B83),
          foregroundColor: Colors.white,
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE0E0E0),
          thickness: 1,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    
    _controller.forward();
    
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 80,
                    color: const Color(0xFF0A2463),
                  ),
                  const SizedBox(width: 20),
                  Icon(
                    Icons.two_wheeler,
                    size: 80,
                    color: const Color(0xFF0A2463).withOpacity(0.7),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Mileage Calculator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0A2463),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Track your vehicle efficiency',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedVehicleType = 'Car'; // Default vehicle type
  final List<String> _vehicleTypes = ['Car', 'Bike'];
  final List<FuelEntry> _fuelEntries = [];
  final int _maxHistoryEntries = 10;
  
  @override
  void initState() {
    super.initState();
    _loadSavedVehicleType();
    _loadFuelEntries();
  }

  // Load the previously selected vehicle type
  Future<void> _loadSavedVehicleType() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedVehicleType = prefs.getString('selected_vehicle_type') ?? 'Car';
    });
  }

  // Save the selected vehicle type
  Future<void> _saveVehicleType(String vehicleType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_vehicle_type', vehicleType);
  }
  
  Future<void> _loadFuelEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('fuel_entries') ?? [];
    
    setState(() {
      _fuelEntries.clear();
      for (var entryJson in entriesJson) {
        _fuelEntries.add(FuelEntry.fromJson(json.decode(entryJson)));
      }
      _fuelEntries.sort((a, b) => b.date.compareTo(a.date));
    });
  }
  
  Future<void> _saveFuelEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = _fuelEntries.map((entry) => 
      json.encode(entry.toJson())).toList();
    
    await prefs.setStringList('fuel_entries', entriesJson);
  }

  // Get only entries for the selected vehicle type
  List<FuelEntry> get _filteredEntries {
    return _fuelEntries.where((entry) => entry.vehicleType == _selectedVehicleType).toList();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mileage Calculator'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Column(
        children: [
          // Vehicle Type Selector Card
          Card(
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
                    selected: {_selectedVehicleType},
                    onSelectionChanged: (Set<String> newSelection) {
                      setState(() {
                        _selectedVehicleType = newSelection.first;
                        _saveVehicleType(_selectedVehicleType);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Stats Card
          if (_filteredEntries.isNotEmpty)
            _buildStatsCard(),
          
          // History Title with Vehicle Icon
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedVehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler,
                  color: const Color(0xFF0A2463),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_selectedVehicleType Fueling History',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          // Fuel Entry History
          Expanded(
            child: _filteredEntries.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedVehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No $_selectedVehicleType entries yet.\nAdd your first fueling record.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      final mileage = _calculateMileage(entry, 
                          index < _filteredEntries.length - 1 ? _filteredEntries[index + 1] : null);
                      
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFF0A2463).withOpacity(0.1),
                            child: Icon(
                              entry.vehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler,
                              color: const Color(0xFF0A2463),
                            ),
                          ),
                          title: Text(
                            'Date: ${DateFormat('MMM dd, yyyy').format(entry.date)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Odometer: ${entry.odometer.toStringAsFixed(1)} km'),
                              Text('Fuel: ${entry.fuelAmount.toStringAsFixed(2)} liters'),
                              if (mileage != null)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A2463).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Mileage: ${mileage.toStringAsFixed(2)} km/l',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0A2463),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditEntryDialog(entry, index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteEntry(index),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEntryDialog,
        icon: const Icon(Icons.add),
        label: Text('Add $_selectedVehicleType Entry'),
      ),
    );
  }
  
  Widget _buildStatsCard() {
    double? avgMileage;
    double totalFuel = 0;
    double? latestMileage;
    double totalDistance = 0;
    
    if (_filteredEntries.length >= 2) {
      double totalFuelUsed = 0;
      
      for (int i = 0; i < _filteredEntries.length - 1; i++) {
        final currentEntry = _filteredEntries[i];
        final previousEntry = _filteredEntries[i + 1];
        
        final distance = currentEntry.odometer - previousEntry.odometer;
        if (distance > 0) {
          totalDistance += distance;
          totalFuelUsed += previousEntry.fuelAmount;
          
          if (i == 0) {
            latestMileage = distance / previousEntry.fuelAmount;
          }
        }
      }
      
      if (totalFuelUsed > 0) {
        avgMileage = totalDistance / totalFuelUsed;
      }
      
      for (var entry in _filteredEntries) {
        totalFuel += entry.fuelAmount;
      }
    }
    
    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _selectedVehicleType == 'Car' ? Icons.analytics : Icons.bar_chart,
                  color: const Color(0xFF0A2463),
                ),
                const SizedBox(width: 8),
                Text(
                  '$_selectedVehicleType Statistics',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0A2463).withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    'Avg. Mileage',
                    avgMileage != null ? '${avgMileage.toStringAsFixed(2)} km/l' : 'N/A',
                    Icons.speed,
                  ),
                  _buildStatItem(
                    'Latest Mileage',
                    latestMileage != null ? '${latestMileage.toStringAsFixed(2)} km/l' : 'N/A',
                    Icons.trending_up,
                  ),
                  _buildStatItem(
                    'Total Distance',
                    '${totalDistance.toStringAsFixed(1)} km',
                    Icons.map,
                  ),
                  _buildStatItem(
                    'Total Fuel',
                    '${totalFuel.toStringAsFixed(2)} L',
                    Icons.local_gas_station,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF0A2463)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
  
  double? _calculateMileage(FuelEntry currentEntry, FuelEntry? previousEntry) {
    if (previousEntry == null) return null;
    
    final distance = currentEntry.odometer - previousEntry.odometer;
    if (distance <= 0 || previousEntry.fuelAmount <= 0) return null;
    
    return distance / previousEntry.fuelAmount;
  }

  void _showEditEntryDialog(FuelEntry entry, int index) {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(entry.date),
    );
    final odometerController = TextEditingController(
      text: entry.odometer.toString(),
    );
    final fuelAmountController = TextEditingController(
      text: entry.fuelAmount.toString(),
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $_selectedVehicleType Entry'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: entry.date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  
                  if (date != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              TextFormField(
                controller: odometerController,
                decoration: const InputDecoration(
                  labelText: 'Odometer Reading (km)',
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: fuelAmountController,
                decoration: const InputDecoration(
                  labelText: 'Fuel Added (liters)',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () {
              try {
                final date = DateFormat('yyyy-MM-dd').parse(dateController.text);
                final odometer = double.parse(odometerController.text);
                final fuelAmount = double.parse(fuelAmountController.text);
                
                if (odometer <= 0 || fuelAmount <= 0) {
                  throw const FormatException('Values must be greater than zero');
                }
                
                _updateFuelEntry(
                  index,
                  date,
                  odometer,
                  fuelAmount,
                );
                
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter valid numbers'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }
  
  void _showAddEntryDialog() {
    final dateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    final odometerController = TextEditingController();
    final fuelAmountController = TextEditingController();
    
    // Pre-populate with last odometer reading if available
    if (_filteredEntries.isNotEmpty) {
      odometerController.text = (_filteredEntries.first.odometer + 100).toStringAsFixed(1);
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $_selectedVehicleType Fueling Record'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: 'Date (YYYY-MM-DD)',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  
                  if (date != null) {
                    dateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              TextFormField(
                controller: odometerController,
                decoration: const InputDecoration(
                  labelText: 'Odometer Reading (km)',
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: fuelAmountController,
                decoration: const InputDecoration(
                  labelText: 'Fuel Added (liters)',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () {
              try {
                final date = DateFormat('yyyy-MM-dd').parse(dateController.text);
                final odometer = double.parse(odometerController.text);
                final fuelAmount = double.parse(fuelAmountController.text);
                
                if (odometer <= 0 || fuelAmount <= 0) {
                  throw const FormatException('Values must be greater than zero');
                }
                
                _addFuelEntry(
                  date,
                  odometer,
                  fuelAmount,
                  _selectedVehicleType,
                );
                
                Navigator.of(context).pop();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter valid numbers'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('SAVE'),
          ),
        ],
      ),
    );
  }
  
  void _addFuelEntry(DateTime date, double odometer, double fuelAmount, String vehicleType) {
    setState(() {
      _fuelEntries.insert(
        0,
        FuelEntry(
          date: date,
          odometer: odometer,
          fuelAmount: fuelAmount,
          vehicleType: vehicleType,
        ),
      );
      
      // Sort entries by date (newest first)
      _fuelEntries.sort((a, b) => b.date.compareTo(a.date));
      
      // Keep only the last N entries for each vehicle type
      final carEntries = _fuelEntries.where((e) => e.vehicleType == 'Car').toList();
      final bikeEntries = _fuelEntries.where((e) => e.vehicleType == 'Bike').toList();
      
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
    });
    
    _saveFuelEntries();
  }
  
  void _updateFuelEntry(int index, DateTime date, double odometer, double fuelAmount) {
    final vehicleType = _filteredEntries[index].vehicleType;
    final originalIndex = _fuelEntries.indexOf(_filteredEntries[index]);
    
    if (originalIndex >= 0) {
      setState(() {
        _fuelEntries[originalIndex] = FuelEntry(
          date: date,
          odometer: odometer,
          fuelAmount: fuelAmount,
          vehicleType: vehicleType,
        );
        
        // Re-sort entries by date
        _fuelEntries.sort((a, b) => b.date.compareTo(a.date));
      });
      
      _saveFuelEntries();
    }
  }
  
  void _deleteEntry(int index) {
    final originalIndex = _fuelEntries.indexOf(_filteredEntries[index]);
    
    if (originalIndex >= 0) {
      setState(() {
        _fuelEntries.removeAt(originalIndex);
      });
      
      _saveFuelEntries();
    }
  }
}

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