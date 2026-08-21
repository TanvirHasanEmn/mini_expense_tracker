import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_expense_tracker/core/utils/app_colors.dart';
import 'widgets/expense_details_widget.dart';

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});

  void _showDeleteDialog(BuildContext context, String expenseId) {
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
            onPressed: () {
              Navigator.of(dialogContext).pop();
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
    final expenses = List.generate(
      15,
          (index) => {
        'id': 'exp_$index',
        'amount': (index + 1) * 250.0,
        'category': index % 2 == 0 ? 'Food & Dining' : 'Transportation',
        'note': index % 3 == 0
            ? 'Lunch with team at restaurant'
            : 'Daily commute to office',
        'createdAt': DateTime.now().subtract(Duration(days: index)),
        'updatedAt': index % 4 == 0 ? DateTime.now() : null,
      },
    );

    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: Text(
          'All Expenses',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.black,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back, color: AppColor.white, size: 24.sp),
        ),
      ),
      body: expenses.isEmpty
          ? Center(
        child: Text(
          'No expenses recorded yet',
          style: GoogleFonts.inter(color: AppColor.lightGray, fontSize: 16.sp),
        ),
      )
          : ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        physics: const BouncingScrollPhysics(),
        itemCount: expenses.length,
        separatorBuilder: (_, __) => 14.verticalSpace,
        itemBuilder: (context, index) {
          final item = expenses[index];
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
              _showDeleteDialog(context, item['id'] as String);
            },
          );
        },
      ),
    );
  }
}