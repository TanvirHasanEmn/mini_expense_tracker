import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/utils/app_colors.dart';

class ExpenseDetailsWidget extends StatelessWidget {
  final double amount;
  final String category;
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ExpenseDetailsWidget({
    super.key,
    required this.amount,
    required this.category,
    this.note,
    required this.createdAt,
    this.updatedAt,
    this.onEdit,
    this.onDelete,
  });

  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
  }

  @override
  Widget build(BuildContext context) {
    final bool isEdited = updatedAt != null;
    final displayDate = isEdited ? updatedAt! : createdAt;
    final dateLabel = isEdited ? "Updated: " : "Created: ";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.subText2.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColor.primary, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.receipt_long_rounded,
                      color:AppColor.primary,
                      size: 20.sp,
                    ),
                    8.horizontalSpace,
                    Flexible(
                      child: Text(
                        category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColor.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'TK. ${amount.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColor.black,
                  ),
                ),
              ),

              8.horizontalSpace,

              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    color: AppColor.primary,
                    size: 16.sp,
                  ),
                ),
              ),

              6.horizontalSpace,

              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: EdgeInsets.all(5.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_outline_rounded,
                    color: AppColor.usRed,
                    size: 16.sp,
                  ),
                ),
              ),
            ],
          ),

          if (note != null && note!.trim().isNotEmpty) ...[
            8.verticalSpace,
            Text(
              note!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColor.lightGray,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],

          10.verticalSpace,

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: AppColor.lightGray,
                size: 12.sp,
              ),
              4.horizontalSpace,
              Text(
                "$dateLabel${_formatDate(displayDate)}",
                style: GoogleFonts.inter(
                  color: AppColor.lightGray,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}