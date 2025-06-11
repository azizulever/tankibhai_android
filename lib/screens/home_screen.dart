import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/controllers/mileage_controller.dart';
import 'package:mileage_calculator/screens/about_screen.dart';
import 'package:mileage_calculator/screens/auth/user_profile_screen.dart';
import 'package:mileage_calculator/screens/auth/welcome_screen.dart';
import 'package:mileage_calculator/screens/detailed_history_screen.dart';
import 'package:mileage_calculator/services/auth_service.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:mileage_calculator/widgets/add_entry_dialog.dart';
import 'package:mileage_calculator/widgets/empty_history_placeholder.dart';
import 'package:mileage_calculator/widgets/fuel_entry_list.dart';
import 'package:mileage_calculator/widgets/main_navigation.dart';
import 'package:mileage_calculator/widgets/vehicle_type_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  final bool showBottomNav;
  
  const HomePage({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MileageGetxController>(
      init: MileageGetxController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'TankiBhai - Fuel Tracker',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            leading: _buildUserNameButton(),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline_rounded),
                tooltip: 'About & Privacy',
              ),
            ],
          ),
          body: Column(
            children: [
              VehicleTypeSelector(
                selectedVehicleType: controller.selectedVehicleType,
                onVehicleTypeChanged: controller.updateSelectedVehicleType,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Divider(color: Colors.grey[300], thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${controller.selectedVehicleType} Overview',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          childAspectRatio:
                              constraints.maxWidth > 600 ? 2.0 : 1.6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          children: [
                            _buildStatCard(
                              context: context,
                              title: 'Avg. Mileage',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.averageMileage
                                          .toStringAsFixed(1),
                              unit: 'KM/L',
                              icon: Icons.speed,
                              isBlue: true,
                            ),
                            _buildStatCard(
                              context: context,
                              title: 'Latest Mileage',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.lastMileage.toStringAsFixed(
                                        1,
                                      ),
                              unit: 'KM/L',
                              icon: Icons.speed,
                              isBlue: false,
                            ),
                            _buildStatCard(
                              context: context,
                              title: 'Avg. Fuel Cost',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.averageFuelPrice
                                          .toStringAsFixed(1),
                              unit: 'TK/L',
                              icon: Icons.payments_outlined,
                              isBlue: false,
                            ),
                            _buildStatCard(
                              context: context,
                              title: 'Latest Fuel Cost',
                              value:
                                  controller.filteredEntries.isEmpty
                                      ? '0.0'
                                      : controller.lastFuelPrice
                                          .toStringAsFixed(1),
                              unit: 'TK/L',
                              icon: Icons.payments_outlined,
                              isBlue: true,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child:
                      controller.filteredEntries.isEmpty
                          ? EmptyHistoryPlaceholder(
                            vehicleType: controller.selectedVehicleType,
                          )
                          : FuelEntryList(
                            entries: controller.filteredEntries,
                            controller: controller,
                          ),
                ),
              ),
            ],
          ),
          // Remove bottomNavigationBar completely - it should only be in MainNavigation
        );
      },
    );
  }

  Widget _buildUserNameButton() {
    return FutureBuilder<String>(
      future: _getUserFirstName(),
      builder: (context, snapshot) {
        final firstName = snapshot.data ?? 'G';
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.offAll(() => const MainNavigation(initialIndex: 3)),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: primaryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  firstName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> _getUserFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    final fullName = prefs.getString('user_name') ?? 'Guest User';
    final firstName = fullName.split(' ').first;
    return firstName.isNotEmpty ? firstName.substring(0, 1) : 'G';
  }

  bool _isUserLoggedIn() {
    try {
      final authService = Get.find<AuthService>();
      return authService.isLoggedIn.value;
    } catch (e) {
      // AuthService not initialized, user is not logged in
      return false;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    final authService = Get.find<AuthService>();
                    await authService.signOut();
                  } catch (e) {
                    // AuthService not found, just clear local storage
                  }
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('skipped_login');
                  Get.offAll(() => const WelcomeScreen());
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required bool isBlue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isBlue ? primaryColor : backgroundColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isBlue ? Colors.white : Colors.black,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isBlue ? primaryColor : backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isBlue ? Colors.blue.shade700 : Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isBlue ? Colors.white : Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: isBlue ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  unit,
                  style: TextStyle(
                    fontSize: 14,
                    color: isBlue ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
