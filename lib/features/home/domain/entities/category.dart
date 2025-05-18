/// Entity representing a video category in the application
class Category {
  final String name;
  final bool isSelected;

  const Category({
    required this.name,
    this.isSelected = false,
  });

  /// Create a copy of this category with modified properties
  Category copyWith({
    String? name,
    bool? isSelected,
  }) {
    return Category(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
