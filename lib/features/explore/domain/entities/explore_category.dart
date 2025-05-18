/// Entity representing a category in the explore screen
class ExploreCategory {
  final String id;
  final String title;
  final String icon;
  final String gradientStart;
  final String gradientEnd;

  const ExploreCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradientStart,
    required this.gradientEnd,
  });
}
