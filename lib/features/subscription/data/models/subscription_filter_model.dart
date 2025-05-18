import '../../domain/entities/subscription_filter.dart';

/// Data model for subscription filters
class SubscriptionFilterModel extends SubscriptionFilter {
  const SubscriptionFilterModel({
    required super.name,
    super.isSelected,
  });

  /// Create a model from JSON
  factory SubscriptionFilterModel.fromJson(String name, {bool isSelected = false}) {
    return SubscriptionFilterModel(
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

  /// Create a copy of this filter with modified properties
  @override
  SubscriptionFilterModel copyWith({
    String? name,
    bool? isSelected,
  }) {
    return SubscriptionFilterModel(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
