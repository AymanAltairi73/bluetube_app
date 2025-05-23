import '../../domain/entities/user_entity.dart';

/// User model extending the UserEntity
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.photoUrl,
    required super.isEmailVerified,
    required super.createdAt,
    super.phoneNumber,
  });

  /// Create a UserModel from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['photo_url'],
      isEmailVerified: json['is_email_verified'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      phoneNumber: json['phone_number'],
    );
  }

  /// Convert the UserModel to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photo_url': photoUrl,
      'is_email_verified': isEmailVerified,
      'created_at': createdAt.toIso8601String(),
      'phone_number': phoneNumber,
    };
  }

  /// Create a copy of the UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    bool? isEmailVerified,
    DateTime? createdAt,
    String? phoneNumber,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
