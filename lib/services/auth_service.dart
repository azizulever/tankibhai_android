import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Mock auth service for when Firebase is not configured
class AuthService extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  Future<bool> registerWithEmail(String email, String password, {String? name}) async {
    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful registration
      isLoggedIn.value = true;
      
      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', name ?? 'User');
      
      Get.snackbar(
        'Success',
        'Account created successfully',
        backgroundColor: primaryColor,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Registration Error',
        'An error occurred during registration',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful login
      isLoggedIn.value = true;
      
      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', 'John Doe'); // Mock name
      
      Get.snackbar(
        'Success',
        'Logged in successfully',
        backgroundColor: primaryColor,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
      );
      return true;
    } catch (e) {
      Get.snackbar('Login Error', 'Invalid email or password');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      isLoading.value = true;
      // Simulate Google sign-in
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful Google sign-in
      isLoggedIn.value = true;
      
      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', 'user@gmail.com');
      await prefs.setString('user_name', 'Google User');
      
      Get.snackbar(
        'Success',
        'Signed in with Google successfully',
        backgroundColor: primaryColor,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Google Sign-In Error',
        'An error occurred during Google sign-in',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      // Simulate sending password reset email
      await Future.delayed(const Duration(seconds: 2));
      Get.snackbar(
        'Success',
        'Password reset email sent to $email',
        backgroundColor: primaryColor,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        shouldIconPulse: false,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while sending reset email');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoggedIn.value = false;
    
    // Clear user data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    
    Get.snackbar(
      'Success',
      'Logged out successfully',
      backgroundColor: primaryColor,
      colorText: Colors.white,
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
      snackPosition: SnackPosition.TOP,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      shouldIconPulse: false,
      duration: const Duration(seconds: 3),
    );
  }
}
