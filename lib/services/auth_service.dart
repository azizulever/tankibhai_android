import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Mock auth service for when Firebase is not configured
class AuthService extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;

  Future<bool> registerWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock successful registration
      isLoggedIn.value = true;
      Get.snackbar(
        'Success',
        'Account created successfully',
        backgroundColor: const Color(0xFF0045ED),
        colorText: const Color(0xFFFFFFFF),
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
      Get.snackbar(
        'Success',
        'Logged in successfully',
        backgroundColor: const Color(0xFF0045ED),
        colorText: const Color(0xFFFFFFFF),
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
      Get.snackbar(
        'Success',
        'Signed in with Google successfully',
        backgroundColor: const Color(0xFF0045ED),
        colorText: const Color(0xFFFFFFFF),
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
        backgroundColor: const Color(0xFF0045ED),
        colorText: const Color(0xFFFFFFFF),
      );
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while sending reset email');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    isLoggedIn.value = false;
    Get.snackbar(
      'Success',
      'Logged out successfully',
      backgroundColor: const Color(0xFF0045ED),
      colorText: const Color(0xFFFFFFFF),
    );
  }
}
