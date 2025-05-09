import 'package:flutter/material.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/models/fuel_entry.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:mileage_calculator/widgets/fuel_entry_list.dart';

class TabbedFuelHistory extends StatefulWidget {
  final List<FuelEntry> entries;
  final MileageGetxController controller;
  final String vehicleType;

  const TabbedFuelHistory({
    required this.entries,
    required this.controller,
    required this.vehicleType,
    Key? key,
  }) : super(key: key);

  @override
  State<TabbedFuelHistory> createState() => _TabbedFuelHistoryState();
}

class _TabbedFuelHistoryState extends State<TabbedFuelHistory> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[700],
            indicator: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(25),
            ),
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'All History'),
              Tab(text: 'Recent'),
              Tab(text: 'Best Mileage'),
            ],
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            padding: const EdgeInsets.all(3),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // All History Tab
              FuelEntryList(
                entries: widget.entries,
                controller: widget.controller,
                listType: "all",
              ),
                
              // Recent Tab
              FuelEntryList(
                entries: widget.entries,
                controller: widget.controller,
                listType: "recent",
              ),
                
              // Best Mileage Tab
              FuelEntryList(
                entries: widget.entries,
                controller: widget.controller,
                listType: "best",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
