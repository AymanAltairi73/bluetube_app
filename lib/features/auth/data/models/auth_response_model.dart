import '../../domain/entities/auth_response_entity.dart';
import 'user_model.dart';

/// Authentication response model extending the AuthResponseEntity
class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required UserModel user,
    required super.accessToken,
    required super.refreshToken,
    required super.expiresAt,
  }) : super(user: user);

  /// Create an AuthResponseModel from a JSON map
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      user: UserModel.fromJson(json['user']),
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  /// Convert the AuthResponseModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'user': (user as UserModel).toJson(),
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}
