import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mini_expense_tracker/core/utils/app_colors.dart';
import '../domain/expense_repo.dart';
import 'widgets/expense_details_widget.dart';

class ExpenseListPage extends ConsumerWidget {
  const ExpenseListPage({super.key});

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
              } catch (e) {
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
    final expensesAsync = ref.watch(expensesStreamProvider);

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
      body: expensesAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColor.primary),
        ),
        error: (error, stack) => Center(
          child: Text(
            'Failed to load expenses',
            style: GoogleFonts.inter(color: AppColor.usRed, fontSize: 16.sp),
          ),
        ),
        data: (expenses) {
          if (expenses.isEmpty) {
            return Center(
              child: Text(
                'No expenses recorded yet',
                style: GoogleFonts.inter(color: AppColor.lightGray, fontSize: 16.sp),
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            physics: const BouncingScrollPhysics(),
            itemCount: expenses.length,
            separatorBuilder: (_, __) => 14.verticalSpace,
            itemBuilder: (context, index) {
              final item = expenses[index];
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
    );
  }
}