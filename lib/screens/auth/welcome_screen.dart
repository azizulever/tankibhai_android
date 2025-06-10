import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/screens/auth/login_screen.dart';
import 'package:mileage_calculator/screens/auth/registration_screen.dart';
import 'package:mileage_calculator/screens/home_screen.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryColor.withOpacity(0.05),
              backgroundColor,
              primaryColor.withOpacity(0.02),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: SizedBox(
              height: 700,
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Hero Section with App Logo
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Logo with modern circular background
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.15),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                                spreadRadius: 4,
                              ),
                            ],
                            border: Border.all(
                              color: primaryColor.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(24),
                            child: Icon(
                              Icons.local_gas_station_rounded,
                              color: primaryColor,
                              size: 48,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // App Title with modern typography
                        const Text(
                          'TankiBhai',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Subtitle with fuel tracking context
                        Text(
                          'Smart Fuel Tracking',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 16),

                        // Description with fuel-related context
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Track fuel consumption • Monitor expenses • Optimize mileage • Save money on every trip',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action Buttons Section
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Primary CTA Button
                        _buildModernButton(
                          onPressed: () => Get.to(() => const RegistrationScreen()),
                          text: 'Get Started',
                          isPrimary: true,
                          icon: Icons.rocket_launch_rounded,
                        ),

                        // Secondary Button
                        _buildModernButton(
                          onPressed: () => Get.to(() => const LoginScreen()),
                          text: 'I have an account',
                          isPrimary: false,
                          icon: Icons.login_rounded,
                        ),

                        // Continue without account
                        TextButton.icon(
                          onPressed: () => _showRunWithoutLoginDialog(context),
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          label: Text(
                            'Continue without account',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required String text,
    required bool isPrimary,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      height: 50,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 16,
          color: isPrimary ? Colors.white : primaryColor,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : primaryColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? primaryColor : Colors.white,
          foregroundColor: isPrimary ? Colors.white : primaryColor,
          elevation: 0,
          side: isPrimary
              ? null
              : BorderSide(
                  color: primaryColor.withOpacity(0.3),
                  width: 1.5,
                ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  void _showRunWithoutLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.all(20),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 24),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Data Security Warning',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: const Text(
          'Running without login means your data will only be stored locally. '
          'Clearing cache/data, uninstalling the app, or cleaning phone storage '
          'will permanently remove all your fuel tracking data.',
          style: TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _setSkippedLogin();
              Get.offAll(() => const HomePage());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  Future<void> _setSkippedLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skipped_login', true);
  }
}
