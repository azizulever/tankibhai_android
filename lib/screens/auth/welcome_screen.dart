import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    
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
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.06,
              vertical: screenHeight * 0.02,
            ),
            child: SizedBox(
              height: screenHeight - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom - (screenHeight * 0.04),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.03), // Reduced from 0.05
                  
                  // Hero Section with App Logo
                  Expanded(
                    flex: 4, // Increased from 3
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Logo with modern circular background
                        Container(
                          width: screenWidth * 0.25, // Reduced from 0.28
                          height: screenWidth * 0.25, // Reduced from 0.28
                          constraints: const BoxConstraints(
                            minWidth: 90, // Reduced from 100
                            maxWidth: 120, // Reduced from 140
                            minHeight: 90, // Reduced from 100
                            maxHeight: 120, // Reduced from 140
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.15),
                                blurRadius: 20, // Reduced from 30
                                offset: const Offset(0, 8), // Reduced from 10
                                spreadRadius: 3, // Reduced from 5
                              ),
                            ],
                            border: Border.all(
                              color: primaryColor.withOpacity(0.1),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(screenWidth * 0.05), // Reduced from 0.06
                            child: SvgPicture.asset(
                              'assets/app_icon.svg',
                              colorFilter: const ColorFilter.mode(
                                primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.03), // Reduced from 0.04
                        
                        // App Title with modern typography
                        Text(
                          'TankiBhai',
                          style: TextStyle(
                            fontSize: screenWidth * 0.08, // Reduced from 0.09
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: -1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: screenHeight * 0.008), // Reduced from 0.01
                        
                        // Subtitle with fuel tracking context
                        Text(
                          'Smart Fuel Tracking',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04, // Reduced from 0.045
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        SizedBox(height: screenHeight * 0.015), // Reduced from 0.02
                        
                        // Description with fuel-related context
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04), // Reduced from 0.05
                          child: Text(
                            'Track fuel consumption • Monitor expenses • Optimize mileage • Save money on every trip',
                            style: TextStyle(
                              fontSize: screenWidth * 0.035, // Reduced from 0.04
                              color: Colors.grey[600],
                              height: 1.4, // Reduced from 1.5
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        SizedBox(height: screenHeight * 0.025), // Reduced from 0.04
                        
                        // Feature highlights with fuel icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFeatureItem(
                              icon: Icons.local_gas_station_rounded,
                              label: 'Track Fuel',
                              screenWidth: screenWidth,
                            ),
                            _buildFeatureItem(
                              icon: Icons.timeline_rounded,
                              label: 'Monitor Trends',
                              screenWidth: screenWidth,
                            ),
                            _buildFeatureItem(
                              icon: Icons.savings_rounded,
                              label: 'Save Money',
                              screenWidth: screenWidth,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: screenHeight * 0.02), // Reduced from 0.05
                  
                  // Action Buttons Section
                  Expanded(
                    flex: 2, // Increased from 1
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Changed from end
                      children: [
                        // Primary CTA Button
                        _buildModernButton(
                          onPressed: () => Get.to(() => const RegistrationScreen()),
                          text: 'Get Started',
                          isPrimary: true,
                          icon: Icons.rocket_launch_rounded,
                          screenWidth: screenWidth,
                        ),
                        
                        // Secondary Button
                        _buildModernButton(
                          onPressed: () => Get.to(() => const LoginScreen()),
                          text: 'I have an account',
                          isPrimary: false,
                          icon: Icons.login_rounded,
                          screenWidth: screenWidth,
                        ),
                        
                        // Continue without account
                        TextButton.icon(
                          onPressed: () => _showRunWithoutLoginDialog(context),
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: screenWidth * 0.035, // Reduced from 0.04
                            color: Colors.grey[600],
                          ),
                          label: Text(
                            'Continue without account',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: screenWidth * 0.03, // Reduced from 0.032
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

  Widget _buildFeatureItem({
    required IconData icon,
    required String label,
    required double screenWidth,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(screenWidth * 0.025), // Reduced from 0.03
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: screenWidth * 0.055, // Reduced from 0.06
            ),
          ),
          SizedBox(height: screenWidth * 0.015), // Reduced from 0.02
          Text(
            label,
            style: TextStyle(
              fontSize: screenWidth * 0.028, // Reduced from 0.03
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton({
    required VoidCallback onPressed,
    required String text,
    required bool isPrimary,
    required IconData icon,
    required double screenWidth,
  }) {
    return Container(
      width: double.infinity,
      height: 48, // Reduced from 52
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary ? [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8, // Reduced from 12
            offset: const Offset(0, 4), // Reduced from 6
          ),
        ] : null,
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: screenWidth * 0.04, // Reduced from 0.045
          color: isPrimary ? Colors.white : primaryColor,
        ),
        label: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.035, // Reduced from 0.038
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : primaryColor,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? primaryColor : Colors.white,
          foregroundColor: isPrimary ? Colors.white : primaryColor,
          elevation: 0,
          side: isPrimary ? null : BorderSide(
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
        content: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: const Text(
            'Running without login means your data will only be stored locally. '
            'Clearing cache/data, uninstalling the app, or cleaning phone storage '
            'will permanently remove all your fuel tracking data.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
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
