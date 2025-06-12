import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mileage_calculator/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  RxBool isLoading = false.obs;
  RxBool isLoggedIn = false.obs;
  
  Rx<User?> user = Rx<User?>(null);
  
  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    isLoggedIn.value = user.value != null;
    
    // Listen for authentication state changes
    _auth.authStateChanges().listen((User? firebaseUser) {
      user.value = firebaseUser;
      isLoggedIn.value = firebaseUser != null;
    });
  }
  
  Future<bool> registerWithEmail(String email, String password, {String? name}) async {
    try {
      isLoading.value = true;
      
      // Create user with email and password
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      if (name != null && name.isNotEmpty) {
        await userCredential.user?.updateDisplayName(name);
      }
      
      // Save user data locally
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
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already registered.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'An error occurred during registration.';
      }
      
      Get.snackbar(
        'Registration Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
      
      return false;
    } catch (e) {
      Get.snackbar(
        'Registration Error',
        'An unexpected error occurred during registration.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    try {
      isLoading.value = true;
      
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Get current user's display name or use email as fallback
      String displayName = _auth.currentUser?.displayName ?? 
                          _auth.currentUser?.email?.split('@')[0] ?? 'User';
      
      // Save user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', email);
      await prefs.setString('user_name', displayName);
      
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
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage = 'An error occurred during login.';
      }
      
      Get.snackbar(
        'Login Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
      
      return false;
    } catch (e) {
      Get.snackbar(
        'Login Error',
        'An unexpected error occurred during login.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      isLoading.value = true;
      
      // Start the Google sign-in process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // If user canceled the sign-in
      if (googleUser == null) {
        isLoading.value = false;
        return false;
      }
      
      // Obtain auth details from Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Create Firebase credential with Google tokens
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Sign in to Firebase with Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Save user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_email', googleUser.email);
      await prefs.setString('user_name', googleUser.displayName ?? 'Google User');
      
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
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
      
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      
      await _auth.sendPasswordResetEmail(email: email);
      
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
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email address.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        default:
          errorMessage = 'An error occurred while sending reset email.';
      }
      
      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();
      
      // Sign out from Google if signed in with Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      
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
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred during logout',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
        snackPosition: SnackPosition.TOP,
      );
    }
  }
  
  // Helper method to get current user's data
  String getCurrentUserEmail() {
    return _auth.currentUser?.email ?? 'guest@tankibhai.com';
  }
  
  String getCurrentUserName() {
    return _auth.currentUser?.displayName ?? 'Guest User';
  }
}
