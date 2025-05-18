import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/subscription_filter.dart';

/// Widget to display a row of subscription filters
class SubscriptionFilterRow extends StatelessWidget {
  final List<SubscriptionFilter> filters;
  final Function(String) onFilterTap;

  const SubscriptionFilterRow({
    super.key,
    required this.filters,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        itemBuilder: (context, index) {
          final filter = filters[index];
          return _buildFilterChip(filter);
        },
      ),
    );
  }

  Widget _buildFilterChip(SubscriptionFilter filter) {
    return GestureDetector(
      onTap: () => onFilterTap(filter.name),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: filter.isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd.r),
        ),
        child: Text(
          filter.name,
          style: TextStyle(
            color: filter.isSelected ? Colors.white : Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
