import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../domain/entities/category.dart';

/// Widget to display a category chip in the home feed
class CategoryChip extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryChip({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: category.isSelected ? Colors.black : Colors.grey[200],
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMd.r),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: category.isSelected ? Colors.white : Colors.black,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
