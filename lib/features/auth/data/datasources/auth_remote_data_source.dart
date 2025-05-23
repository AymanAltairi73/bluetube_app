import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

/// Interface for remote authentication data source
abstract class AuthRemoteDataSource {
  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// Register a new user
  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  });

  /// Login with Google
  Future<AuthResponseModel> loginWithGoogle();

  /// Login with Facebook
  Future<AuthResponseModel> loginWithFacebook();



  /// Send password reset email
  Future<bool> forgotPassword(String email);

  /// Refresh authentication token
  Future<AuthResponseModel> refreshToken(String refreshToken);
}

/// Implementation of [AuthRemoteDataSource] with mock authentication
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({
    required this.client,
  });

  // For demo purposes, we'll simulate API calls
  final _random = Random();

  // Simulate network delay with random duration
  Future<void> _simulateNetworkDelay() async {
    // Random delay between 500ms and 1500ms
    final delay = 500 + _random.nextInt(1000);
    await Future.delayed(Duration(milliseconds: delay));

    // Simulate random errors (10% chance)
    if (_random.nextDouble() < 0.1) {
      throw ServerException(message: 'Network error occurred. Please try again.');
    }
  }

  // Generate a mock auth response
  AuthResponseModel _generateMockAuthResponse({
    required String id,
    required String name,
    required String email,
    String? photoUrl,
  }) {
    final user = UserModel(
      id: id,
      name: name,
      email: email,
      photoUrl: photoUrl,
      isEmailVerified: true,
      createdAt: DateTime.now(),
    );

    return AuthResponseModel(
      user: user,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Simulate login validation
    if (email.isEmpty || !email.contains('@')) {
      throw ServerException(message: 'Invalid email format');
    }

    if (password.isEmpty || password.length < 6) {
      throw ServerException(message: 'Password must be at least 6 characters');
    }

    // For demo, we'll accept any valid email/password
    return _generateMockAuthResponse(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: email.split('@').first,
      email: email,
      photoUrl: 'https://ui-avatars.com/api/?name=${email.split('@').first}',
    );
  }

  @override
  Future<AuthResponseModel> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await _simulateNetworkDelay();

    // Simulate signup validation
    if (name.isEmpty) {
      throw ServerException(message: 'Name is required');
    }

    if (email.isEmpty || !email.contains('@')) {
      throw ServerException(message: 'Invalid email format');
    }

    if (password.isEmpty || password.length < 6) {
      throw ServerException(message: 'Password must be at least 6 characters');
    }

    // For demo, we'll accept any valid signup data
    return _generateMockAuthResponse(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      photoUrl: 'https://ui-avatars.com/api/?name=$name',
    );
  }

  @override
  Future<AuthResponseModel> loginWithGoogle() async {
    try {
      await _simulateNetworkDelay();

      // Mock Google sign-in data
      return _generateMockAuthResponse(
        id: 'google_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Google User',
        email: 'google.user@example.com',
        photoUrl: 'https://ui-avatars.com/api/?name=Google+User&background=FF4285F4&color=fff',
      );
    } catch (e) {
      debugPrint('Google sign in error: $e');
      throw ServerException(message: 'Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponseModel> loginWithFacebook() async {
    try {
      await _simulateNetworkDelay();

      // Mock Facebook sign-in data
      return _generateMockAuthResponse(
        id: 'facebook_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Facebook User',
        email: 'facebook.user@example.com',
        photoUrl: 'https://ui-avatars.com/api/?name=Facebook+User&background=1877F2&color=fff',
      );
    } catch (e) {
      debugPrint('Facebook sign in error: $e');
      throw ServerException(message: 'Failed to sign in with Facebook: ${e.toString()}');
    }
  }



  @override
  Future<bool> forgotPassword(String email) async {
    await _simulateNetworkDelay();

    // Simulate email validation
    if (email.isEmpty || !email.contains('@')) {
      throw ServerException(message: 'Invalid email format');
    }

    // For demo, we'll accept any valid email
    return true;
  }

  @override
  Future<AuthResponseModel> refreshToken(String refreshToken) async {
    await _simulateNetworkDelay();

    // Simulate token validation
    if (refreshToken.isEmpty) {
      throw ServerException(message: 'Invalid refresh token');
    }

    // For demo, we'll accept any valid refresh token
    return AuthResponseModel(
      user: UserModel(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: 'Refreshed User',
        email: 'refreshed@example.com',
        isEmailVerified: true,
        createdAt: DateTime.now(),
      ),
      accessToken: 'new_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'new_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(days: 7)),
    );
  }
}
