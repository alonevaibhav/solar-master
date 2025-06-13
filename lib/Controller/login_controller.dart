

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../API Service/api_service.dart';
import '../Model/login_model.dart';
import '../Route Manager/app_routes.dart';
import '../View/Auth/token_manager.dart';
import '../utils/constants.dart';

class LoginController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var errorMessage = ''.obs;
  var selectedRole = ''.obs;

  // Reactive form data
  var loginModel = LoginModel.empty().obs;

  // User profile data - Observable for UI updates
  var currentUserProfile = Rxn<UserProfile>();
  var currentUserName = ''.obs;
  var currentUsername = ''.obs;
  var currentDistributorName = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Load saved user data on initialization
    _loadSavedUserData();

    // Set up form listeners
    usernameController.addListener(() {
      updateLoginModel();
    });

    passwordController.addListener(() {
      updateLoginModel();
    });
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    TokenManager.stopTokenExpirationTimer();
    super.onClose();
  }

  /// Load saved user data from SharedPreferences
  Future<void> _loadSavedUserData() async {
    try {
      final userName = await UserSession.getUserName();
      final username = await UserSession.getUsername();
      final distributorName = await UserSession.getDistributorName();

      if (userName != null) currentUserName.value = userName;
      if (username != null) currentUsername.value = username;
      if (distributorName != null) currentDistributorName.value = distributorName;
    } catch (e) {
      print('Error loading saved user data: $e');
    }
  }

  /// Updates the login model with current field values
  void updateLoginModel() {
    loginModel.value = LoginModel(
      username: usernameController.text,
      password: passwordController.text,
      role: selectedRole.value,
    );
  }

  /// Set selected role
  void setSelectedRole(String role) {
    selectedRole.value = role;
    updateLoginModel();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Validates username format
  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  /// Validates password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  /// Validates role selection
  String? validateRole(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your role';
    }
    return null;
  }

  /// Handles form submission with real API integration
  Future<void> login() async {
    try {
      errorMessage.value = '';

      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      final requestBody = {
        'username': loginModel.value.username,
        'password': loginModel.value.password,
        'role': loginModel.value.role,
      };

      final response = await ApiService.post<LoginApiResponse>(
        endpoint: loginUrl,
        body: requestBody,
        fromJson: (json) => LoginApiResponse.fromJson(json),
        includeToken: false,
      );

      if (response.success && response.data != null) {
        final loginResponse = response.data!;

        if (loginResponse.success && loginResponse.data != null) {
          final loginData = loginResponse.data!;
          final token = loginData.token;

          // Save token first
          await ApiService.setToken(token);

          // Decode token to get 'id'
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
          String userId = decodedToken['id'];
          await ApiService.setUid(userId);

          // Save token and expiration time using TokenManager
          await TokenManager.saveToken(token, expirationTime: loginData.expirationTime);

          // Save user profile data to SharedPreferences and update observables
          await _saveUserProfileData(loginData);

          // Debug logging
          final storedToken = await ApiService.getToken();
          final storedUid = await ApiService.getUid();

          print('Token: $storedToken');
          print('UID from decoded token: $storedUid');
          log('User Profile: ${loginData.profile.name} (${loginData.profile.username})');
          print('Distributor: ${loginData.profile.distributorName}');

          log('Token: $storedToken');
          log('UID: $storedUid');
          log('Profile: ${loginData.profile.toJson()}');

          Get.snackbar(
            'Success',
            'Welcome ${loginData.profile.name}!', // Use profile name in welcome message
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            duration: const Duration(seconds: 2),
          );

          _navigateByRole(UserRole.fromString(loginData.role));
        } else {
          throw Exception(loginResponse.message ?? 'Login failed');
        }
      } else {
        throw Exception(response.errorMessage ?? 'Login failed');
      }
    } catch (e) {
      String errorMsg = e.toString().replaceAll('Exception: ', '');
      errorMessage.value = errorMsg;
      Get.snackbar(
        'Error',
        'Login failed: $errorMsg',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Save user profile data to SharedPreferences and update observables
  Future<void> _saveUserProfileData(LoginData loginData) async {
    try {
      // Save to SharedPreferences using UserSession
      await UserSession.saveSession(
        token: loginData.token,
        role: loginData.role,
        profile: loginData.profile,
      );

      // Update observable variables for immediate UI updates
      currentUserProfile.value = loginData.profile;
      currentUserName.value = loginData.profile.name;
      currentUsername.value = loginData.profile.username;
      currentDistributorName.value = loginData.profile.distributorName;

      // Save additional data to SharedPreferences for backward compatibility
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role', loginData.role);
      await prefs.setString('user_token', loginData.token);
      await prefs.setString('user_name', loginData.profile.name);
      await prefs.setString('username', loginData.profile.username);
      await prefs.setInt('user_id', loginData.profile.id);
      await prefs.setString('distributor_name', loginData.profile.distributorName);

    } catch (e) {
      print('Error saving user profile data: $e');
    }
  }

  /// Navigate user based on their role
  void _navigateByRole(UserRole role) {
    switch (role) {
      case UserRole.cleaner:
        Get.offAllNamed(AppRoutes.cleaner);
        break;
      case UserRole.inspector:
        Get.offAllNamed(AppRoutes.inspector);
        break;
      case UserRole.user:
        Get.snackbar('Info', 'User role navigation not implemented yet');
        break;
    }
  }

  /// Clears all form fields
  void clearForm() {
    usernameController.clear();
    passwordController.clear();
    selectedRole.value = '';
    errorMessage.value = '';
  }

  /// Check if user is already logged in
  Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Logout user and clear stored data
  Future<void> logout({bool sessionExpired = false}) async {
    try {
      isLoading.value = true;

      // Clear API service stored data
      await ApiService.clearAuthData();

      // Clear token and expiration time
      await TokenManager.clearToken();

      // Clear all user session data
      await UserSession.clearSession();

      // Clear observable variables
      currentUserProfile.value = null;
      currentUserName.value = '';
      currentUsername.value = '';
      currentDistributorName.value = '';

      // Clear forms
      clearForm();

      // Navigate to login screen
      if (Get.currentRoute != AppRoutes.login) {
        Get.offAllNamed(AppRoutes.login);
      }

      Get.snackbar(
        sessionExpired ? 'Session Expired' : 'Success',
        sessionExpired ? 'Your session has expired. Please log in again.' : 'Logged out successfully',
        backgroundColor: sessionExpired
            ? Colors.orange.withOpacity(0.1)
            : Colors.green.withOpacity(0.1),
        colorText: sessionExpired ? Colors.orange : Colors.green,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Logout failed: ${e.toString()}',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get current user profile information (useful for UI)
  UserProfile? get userProfile => currentUserProfile.value;
  String get userName => currentUserName.value;
  String get username => currentUsername.value;
  String get distributorName => currentDistributorName.value;
}