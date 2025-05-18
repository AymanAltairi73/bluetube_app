import '../../domain/entities/category.dart';

/// Data model for categories
class CategoryModel extends Category {
  const CategoryModel({
    required super.name,
    super.isSelected,
  });

  /// Create a model from JSON
  factory CategoryModel.fromJson(String name, {bool isSelected = false}) {
    return CategoryModel(
      name: name,
      isSelected: isSelected,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'is_selected': isSelected,
    };
  }

  /// Create a copy of this category with modified properties
  @override
  CategoryModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return CategoryModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
