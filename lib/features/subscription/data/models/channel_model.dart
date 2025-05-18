import '../../domain/entities/channel.dart';

/// Data model for channels
class ChannelModel extends Channel {
  const ChannelModel({
    required super.id,
    required super.name,
    required super.image,
    required super.subscribers,
    required super.hasNewContent,
    required super.isVerified,
    required super.description,
  });

  /// Create a model from JSON
  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      subscribers: json['subscribers'],
      hasNewContent: json['has_new_content'],
      isVerified: json['is_verified'],
      description: json['description'],
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'subscribers': subscribers,
      'has_new_content': hasNewContent,
      'is_verified': isVerified,
      'description': description,
    };
  }
}
