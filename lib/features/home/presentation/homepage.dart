import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/image_paths.dart';
import '../../expense/presentation/widgets/expense_details_widget.dart';
import '../controller/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    final recentExpenses = List.generate(
      5,
          (index) => {
        'id': 'exp_$index',
        'amount': (index + 1) * 320.0,
        'category': index % 2 == 0 ? 'Bills & Utilities' : 'Food & Dining',
        'note': 'Sample note for recent expense item',
        'createdAt': DateTime.now().subtract(Duration(hours: index * 4)),
        'updatedAt': null,
      },
    );

    return Scaffold(
      backgroundColor: AppColor.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mini Expense Tracker',
                        style: GoogleFonts.inter(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColor.primary.withAlpha(120),
                          letterSpacing: 1.1,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 18.r,
                              backgroundColor: AppColor.primary,
                              backgroundImage:
                              const AssetImage(ImagePath.profile),
                            ),
                            4.verticalSpace,
                            Text(
                              'Profile',
                              style: GoogleFonts.inter(
                                color: AppColor.lightGray,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  16.verticalSpace,
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                          color: AppColor.primary, width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME, ${state.userName.toUpperCase()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            color: AppColor.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        14.verticalSpace,
                        _buildExpenseSummaryRow(
                          label: 'Your Monthly Expense',
                          amount: 'TK. 14,500.00',
                        ),
                        10.verticalSpace,
                        _buildExpenseSummaryRow(
                          label: 'Your Total Expense',
                          amount: 'TK. 58,200.00',
                        ),
                      ],
                    ),
                  ),

                  20.verticalSpace,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Expenses',
                        style: GoogleFonts.inter(
                          color: AppColor.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push('/expense_list'),
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            color: AppColor.yellow,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                ],
              ),
            ),
            Expanded(
              child: recentExpenses.isEmpty
                  ? Center(
                child: Text(
                  'No expenses added yet',
                  style: GoogleFonts.inter(
                    color: AppColor.lightGray,
                    fontSize: 14.sp,
                  ),
                ),
              )
                  : ListView.separated(
                padding: EdgeInsets.symmetric(
                    horizontal: 16.w, vertical: 6.h),
                itemCount: recentExpenses.length,
                separatorBuilder: (_, __) => 12.verticalSpace,
                itemBuilder: (context, index) {
                  final item = recentExpenses[index];
                  return ExpenseDetailsWidget(
                    amount: item['amount'] as double,
                    category: item['category'] as String,
                    note: item['note'] as String?,
                    createdAt: item['createdAt'] as DateTime,
                    updatedAt: item['updatedAt'] as DateTime?,
                    onEdit: () {
                      context.push('/edit_expense', extra: item);
                    },
                    onDelete: () {
                    },
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColor.bgColor,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1.w,
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () => context.push('/add_expense'),
                child: Container(
                  height: 56.h,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  decoration: BoxDecoration(
                    color: AppColor.yellow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        color: AppColor.primary, width: 1.w),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add Your New Expense',
                        style: GoogleFonts.inter(
                          color: AppColor.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.add_circle_outline_rounded,
                        color: AppColor.primary,
                        size: 24.sp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseSummaryRow({
    required String label,
    required String amount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: AppColor.lightGray,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ),
        12.horizontalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          constraints: BoxConstraints(
            minWidth: 70.w,
            maxWidth: 140.w,
          ),
          child: Center(
            child: Text(
              amount,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
                color: AppColor.darkText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}