import '../../domain/entities/explore_category.dart';

/// Data model for explore categories
class ExploreCategoryModel extends ExploreCategory {
  const ExploreCategoryModel({
    required super.id,
    required super.title,
    required super.icon,
    required super.gradientStart,
    required super.gradientEnd,
  });

  /// Create a model from JSON
  factory ExploreCategoryModel.fromJson(Map<String, dynamic> json) {
    return ExploreCategoryModel(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],
      gradientStart: json['gradient_start'],
      gradientEnd: json['gradient_end'],
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'gradient_start': gradientStart,
      'gradient_end': gradientEnd,
    };
  }
}
