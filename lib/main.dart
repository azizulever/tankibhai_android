import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mileage_calculator/screens/auth/welcome_screen.dart';
import 'package:mileage_calculator/screens/splash_screen.dart';
import 'package:mileage_calculator/services/auth_service.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:mileage_calculator/widgets/main_navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mileage_calculator/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MileageCalculatorApp());
}

class MileageCalculatorApp extends StatelessWidget {
  const MileageCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TankiBhai',
      theme: appTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _shouldShowWelcome = true;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  Future<void> _checkAuthState() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash screen duration

    final prefs = await SharedPreferences.getInstance();
    final skippedLogin = prefs.getBool('skipped_login') ?? false;
    
    // Initialize auth service and get current Firebase user
    final authService = Get.put(AuthService());
    final currentUser = FirebaseAuth.instance.currentUser;

    if (skippedLogin || currentUser != null) {
      setState(() {
        _shouldShowWelcome = false;
        _isLoading = false;
      });

      if (skippedLogin && currentUser == null) {
        _showDataWarningSnackbar();
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDataWarningSnackbar() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.white),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Your data is stored locally only. Create an account to sync across devices.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SplashScreen();
    }

    return _shouldShowWelcome ? const WelcomeScreen() : const MainNavigation();
  }
}