

import 'package:shared_preferences/shared_preferences.dart';

/// Login request model
class LoginModel {
  final String username;
  final String password;
  final String role;

  const LoginModel({
    required this.username,
    required this.password,
    required this.role,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'role': role,
    };
  }

  LoginModel copyWith({
    String? username,
    String? password,
    String? role,
  }) {
    return LoginModel(
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }

  static LoginModel empty() {
    return const LoginModel(
      username: '',
      password: '',
      role: '',
    );
  }
}

/// Profile model for user details
class UserProfile {
  final int id;
  final String name;
  final String username;
  final int distributorId;
  final int distributorAdminId;
  final int createdByAdmin;
  final int updatedByAdmin;
  final String createdAt;
  final String updatedAt;
  final int isActive;
  final int isDeleted;
  final String lastLoginTime;
  final String lastLoginIp;
  final String info;
  final String distributorName;
  final String distributorAdminName;

  const UserProfile({
    required this.id,
    required this.name,
    required this.username,
    required this.distributorId,
    required this.distributorAdminId,
    required this.createdByAdmin,
    required this.updatedByAdmin,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isDeleted,
    required this.lastLoginTime,
    required this.lastLoginIp,
    required this.info,
    required this.distributorName,
    required this.distributorAdminName,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      distributorId: json['distributor_id'] ?? 0,
      distributorAdminId: json['distributor_admin_id'] ?? 0,
      createdByAdmin: json['created_by_admin'] ?? 0,
      updatedByAdmin: json['updated_by_admin'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      isActive: json['isActive'] ?? 0,
      isDeleted: json['isDeleted'] ?? 0,
      lastLoginTime: json['last_login_time'] ?? '',
      lastLoginIp: json['last_login_ip'] ?? '',
      info: json['info'] ?? '',
      distributorName: json['distributor_name'] ?? '',
      distributorAdminName: json['distributor_admin_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'distributor_id': distributorId,
      'distributor_admin_id': distributorAdminId,
      'created_by_admin': createdByAdmin,
      'updated_by_admin': updatedByAdmin,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'last_login_time': lastLoginTime,
      'last_login_ip': lastLoginIp,
      'info': info,
      'distributor_name': distributorName,
      'distributor_admin_name': distributorAdminName,
    };
  }
}

/// API Response model matching your updated API structure
class LoginApiResponse {
  final String message;
  final bool success;
  final LoginData? data;
  final List<String> errors;

  const LoginApiResponse({
    required this.message,
    required this.success,
    this.data,
    required this.errors,
  });

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    return LoginApiResponse(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data: json['data'] != null ? LoginData.fromJson(json['data']) : null,
      errors: List<String>.from(json['errors'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'success': success,
      'data': data?.toJson(),
      'errors': errors,
    };
  }
}

/// Updated Login data model containing token, role, and profile
class LoginData {
  final String token;
  final String role;
  final UserProfile profile; // Added profile
  final String? expirationTime;

  const LoginData({
    required this.token,
    required this.role,
    required this.profile, // Added profile
    this.expirationTime,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      token: json['token'] ?? '',
      role: json['role'] ?? '',
      profile: UserProfile.fromJson(json['profile'] ?? {}), // Parse profile
      expirationTime: json['expirationTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'role': role,
      'profile': profile.toJson(), // Include profile in JSON
      'expirationTime': expirationTime,
    };
  }

  // Convenience getters for commonly used profile data
  String get userName => profile.name;
  String get username => profile.username;
  int get userId => profile.id;
  String get distributorName => profile.distributorName;
}

/// Updated User model for authenticated user with profile information
class UserModel {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? token;
  final UserProfile? profile; // Added profile

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.token,
    this.profile, // Added profile
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      role: UserRole.fromString(json['role'] ?? 'user'),
      token: json['token'],
      profile: json['profile'] != null ? UserProfile.fromJson(json['profile']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'token': token,
      'profile': profile?.toJson(),
    };
  }
}

/// Enum for user roles
enum UserRole {
  cleaner,
  inspector,
  user;

  static UserRole fromString(String value) {
    switch (value.toLowerCase()) {
      case 'cleaner':
        return UserRole.cleaner;
      case 'inspector':
        return UserRole.inspector;
      default:
        return UserRole.cleaner;
    }
  }

  String get displayName {
    switch (this) {
      case UserRole.cleaner:
        return 'Cleaner';
      case UserRole.inspector:
        return 'Inspector';
      case UserRole.user:
        return 'User';
    }
  }
}

/// Response model for login API call (keeping for backward compatibility)
class LoginResponse {
  final bool success;
  final String? message;
  final UserModel? user;

  const LoginResponse({
    required this.success,
    this.message,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'user': user?.toJson(),
    };
  }
}

/// Updated Utility class for handling user session with profile data
class UserSession {
  static const String _tokenKey = 'user_token';
  static const String _roleKey = 'user_role';
  static const String _emailKey = 'user_email';
  static const String _userNameKey = 'user_name'; // Added
  static const String _usernameKey = 'username'; // Added
  static const String _userIdKey = 'user_id'; // Added
  static const String _distributorNameKey = 'distributor_name'; // Added
  static const String _profileKey = 'user_profile'; // Added for full profile

  /// Save user session data with profile information
  static Future<void> saveSession({
    required String token,
    required String role,
    String? email,
    UserProfile? profile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_roleKey, role);

    if (email != null) {
      await prefs.setString(_emailKey, email);
    }

    if (profile != null) {
      await prefs.setString(_userNameKey, profile.name);
      await prefs.setString(_usernameKey, profile.username);
      await prefs.setInt(_userIdKey, profile.id);
      await prefs.setString(_distributorNameKey, profile.distributorName);
      // Save full profile as JSON string if needed
      await prefs.setString(_profileKey, profile.toJson().toString());
    }
  }

  /// Get saved token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  /// Get saved role
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Get saved email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey);
  }

  /// Get saved user name
  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  /// Get saved username
  static Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  /// Get saved user ID
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  /// Get saved distributor name
  static Future<String?> getDistributorName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_distributorNameKey);
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear all session data
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_distributorNameKey);
    await prefs.remove(_profileKey);
  }

  /// Get user role as enum
  static Future<UserRole?> getUserRole() async {
    final role = await getRole();
    if (role != null) {
      return UserRole.fromString(role);
    }
    return null;
  }
}