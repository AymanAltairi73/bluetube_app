import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Interface for local authentication data source
abstract class AuthLocalDataSource {
  /// Save authentication response
  Future<void> saveAuthResponse(AuthResponseModel authResponse);

  /// Get saved authentication response
  Future<AuthResponseModel?> getAuthResponse();

  /// Clear authentication data
  Future<bool> clearAuthData();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Get current user
  Future<UserModel?> getCurrentUser();
}

/// Implementation of [AuthLocalDataSource] using FlutterSecureStorage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  // Storage keys
  static const String authResponseKey = 'auth_response';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveAuthResponse(AuthResponseModel authResponse) async {
    try {
      final jsonString = json.encode(authResponse.toJson());
      await secureStorage.write(key: authResponseKey, value: jsonString);
    } catch (e) {
      throw CacheException(message: 'Failed to save auth data: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel?> getAuthResponse() async {
    try {
      final jsonString = await secureStorage.read(key: authResponseKey);
      if (jsonString == null) {
        return null;
      }
      return AuthResponseModel.fromJson(json.decode(jsonString));
    } catch (e) {
      throw CacheException(message: 'Failed to get auth data: ${e.toString()}');
    }
  }

  @override
  Future<bool> clearAuthData() async {
    try {
      await secureStorage.delete(key: authResponseKey);
      return true;
    } catch (e) {
      throw CacheException(message: 'Failed to clear auth data: ${e.toString()}');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      final authResponse = await getAuthResponse();
      if (authResponse == null) {
        return false;
      }
      
      // Check if token is expired
      final now = DateTime.now();
      return authResponse.expiresAt.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final authResponse = await getAuthResponse();
      if (authResponse == null) {
        return null;
      }
      return authResponse.user as UserModel;
    } catch (e) {
      throw CacheException(message: 'Failed to get current user: ${e.toString()}');
    }
  }
}
