/// Entity representing a filter for subscription videos
class SubscriptionFilter {
  final String name;
  final bool isSelected;

  const SubscriptionFilter({
    required this.name,
    this.isSelected = false,
  });

  /// Create a copy of this filter with modified properties
  SubscriptionFilter copyWith({
    String? name,
    bool? isSelected,
  }) {
    return SubscriptionFilter(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
