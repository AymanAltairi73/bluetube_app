import 'package:equatable/equatable.dart';

/// User entity representing a user in the application
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final bool isEmailVerified;
  final DateTime createdAt;
  final String? phoneNumber;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.isEmailVerified,
    required this.createdAt,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        photoUrl,
        isEmailVerified,
        createdAt,
        phoneNumber,
      ];
}
