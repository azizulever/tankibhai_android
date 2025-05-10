import 'package:flutter/material.dart';
import 'package:mileage_calculator/utils/theme.dart';

class CustomTabBar extends StatefulWidget {
  final List<String> tabs;
  final Function(int) onTabChanged;
  final int initialIndex;

  const CustomTabBar({
    Key? key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Reduced vertical margin
      padding: const EdgeInsets.all(3), // Reduced padding
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: List.generate(
          widget.tabs.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
                widget.onTabChanged(index);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8), // Reduced padding
                decoration: BoxDecoration(
                  color: _selectedIndex == index ? primaryColor : Colors.transparent, // Use theme color
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    widget.tabs[index],
                    style: TextStyle(
                      color: _selectedIndex == index ? Colors.white : Colors.grey[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 13, // Smaller font
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
