import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/image_paths.dart';
import '../../expense/domain/expense_repo.dart';
import '../../expense/presentation/widgets/expense_details_widget.dart';
import '../controller/home_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _showDeleteDialog(BuildContext context, WidgetRef ref, String expenseId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: Color(0xFF333333)),
        ),
        title: Text(
          'Delete Expense',
          style: GoogleFonts.inter(
            color: AppColor.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this expense record?',
          style: GoogleFonts.inter(
            color: AppColor.lightGray,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColor.lightGray, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              try {
                await ref.read(expenseRepositoryProvider).deleteExpense(expenseId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Expense deleted'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete expense'),
                      backgroundColor: AppColor.usRed,
                    ),
                  );
                }
              }
            },
            child: Text(
              'Delete',
              style: GoogleFonts.inter(
                color: AppColor.usRed,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final expensesAsync = ref.watch(expensesStreamProvider);

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
                        color: AppColor.primary,
                        width: 1.w,
                      ),
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
                          amount: 'TK. ${state.monthlyExpense.toStringAsFixed(2)}',
                        ),
                        10.verticalSpace,
                        _buildExpenseSummaryRow(
                          label: 'Your Total Expense',
                          amount: 'TK. ${state.totalExpense.toStringAsFixed(2)}',
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
              child: expensesAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColor.primary),
                ),
                error: (_, __) => Center(
                  child: Text(
                    'Failed to load expenses',
                    style: GoogleFonts.inter(
                      color: AppColor.usRed,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
                data: (expenses) {
                  // Display only the 5 most recent records on the dashboard
                  final recentExpenses = expenses.take(5).toList();

                  if (recentExpenses.isEmpty) {
                    return Center(
                      child: Text(
                        'No expenses added yet',
                        style: GoogleFonts.inter(
                          color: AppColor.lightGray,
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    itemCount: recentExpenses.length,
                    separatorBuilder: (_, __) => 12.verticalSpace,
                    itemBuilder: (context, index) {
                      final item = recentExpenses[index];
                      return ExpenseDetailsWidget(
                        amount: item.amount,
                        category: item.category,
                        note: item.note,
                        createdAt: item.createdAt,
                        updatedAt: item.updatedAt,
                        onEdit: () {
                          context.push(
                            '/edit_expense',
                            extra: {
                              'id': item.expenseId,
                              'amount': item.amount,
                              'category': item.category,
                              'note': item.note,
                              'createdAt': item.createdAt,
                              'updatedAt': item.updatedAt,
                            },
                          );
                        },
                        onDelete: () {
                          _showDeleteDialog(context, ref, item.expenseId);
                        },
                      );
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
                      color: AppColor.primary,
                      width: 1.w,
                    ),
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