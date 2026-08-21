import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/custom_widgets/custom_button.dart';
import '../../../core/utils/app_colors.dart';
import '../controller/edit_expenses_controller.dart';

class EditExpensePage extends ConsumerWidget {
  final Map<String, dynamic> expenseData;

  const EditExpensePage({
    super.key,
    required this.expenseData,
  });

  Future<void> _pickDate(BuildContext context, WidgetRef ref, DateTime currentDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColor.primary,
              onPrimary: AppColor.black,
              surface: AppColor.darkGray,
              onSurface: AppColor.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      ref.read(editExpenseControllerProvider(expenseData).notifier).selectDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editExpenseControllerProvider(expenseData));
    final controller = ref.read(editExpenseControllerProvider(expenseData).notifier);

    ref.listen(editExpenseControllerProvider(expenseData), (previous, next) {
      if (next.generalError != null && next.generalError != previous?.generalError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.generalError!),
            backgroundColor: AppColor.usRed,
          ),
        );
      }
      if (next.isSuccess && !(previous?.isSuccess ?? false)) {
        context.pop();
      }
    });

    final formattedDate = state.selectedDate != null
        ? "${state.selectedDate!.day.toString().padLeft(2, '0')}/${state.selectedDate!.month.toString().padLeft(2, '0')}/${state.selectedDate!.year}"
        : "Select Date";

    return Scaffold(
      backgroundColor: AppColor.black,
      appBar: AppBar(
        title: Text(
          'Edit Expense',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Total Expense Amount (TK)'),
            8.verticalSpace,
            TextField(
              controller: controller.amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.inter(fontSize: 15.sp, color:AppColor.white),
              decoration: _inputDecoration('e.g. 500', errorText: state.amountError),
            ),
            16.verticalSpace,

            _buildLabel('Category'),
            8.verticalSpace,
            DropdownButtonFormField<String>(
              value: state.selectedCategory,
              hint: Text(
                'Select Category',
                style: GoogleFonts.inter(
                  color: AppColor.lightGray,
                  fontSize: 14.sp,
                ),
              ),
              items: state.categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(
                    category,
                    style: GoogleFonts.inter(fontSize: 15.sp, color: AppColor.white),
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) controller.selectCategory(val);
              },
              dropdownColor: const Color(0xFF1E1E1E),
              icon: Icon(Icons.arrow_drop_down, color:AppColor.primary, size: 24.sp),
              style: GoogleFonts.inter(fontSize: 15.sp, color: AppColor.white),
              decoration: _inputDecoration(
                '',
                errorText: state.categoryError,
              ),
            ),
            16.verticalSpace,

            _buildLabel('Date'),
            8.verticalSpace,
            GestureDetector(
              onTap: () => _pickDate(context, ref, state.selectedDate ?? DateTime.now()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 54.h,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    decoration: BoxDecoration(
                      color: AppColor.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(
                        color: state.dateError != null
                            ? AppColor.usRed
                            :AppColor.primary,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formattedDate,
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            color: AppColor.white,
                          ),
                        ),
                        Icon(
                          Icons.calendar_month_rounded,
                          color:AppColor.primary,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                  if (state.dateError != null) ...[
                    6.verticalSpace,
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: Text(
                        state.dateError!,
                        style: GoogleFonts.inter(color:AppColor.usRed, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            16.verticalSpace,

            _buildLabel('Note (Optional)'),
            8.verticalSpace,
            TextField(
              controller: controller.noteController,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              style: GoogleFonts.inter(fontSize: 15.sp, color: AppColor.white),
              decoration: InputDecoration(
                hintText: 'Type any details or notes here...',
                hintStyle: GoogleFonts.inter(color: AppColor.lightGray, fontSize: 14.sp),
                filled: true,
                fillColor: AppColor.primary.withValues(alpha: 0.15),
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: AppColor.primary),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.r),
                  borderSide: const BorderSide(color: AppColor.primary),
                ),
              ),
            ),
            30.verticalSpace,

            CustomButton(
              text: state.isLoading ? 'Updating...' : 'Update Expense',
              onPressed: state.isLoading ? null : controller.updateExpense,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.white,
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText, {String? errorText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.inter(color: AppColor.lightGray, fontSize: 14.sp),
      errorText: errorText,
      errorStyle: GoogleFonts.inter(color: AppColor.usRed, fontSize: 12.sp),
      filled: true,
      fillColor: AppColor.primary.withValues(alpha: 0.15),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.r),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.r),
        borderSide: const BorderSide(color:AppColor.primary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(100.r),
        borderSide: const BorderSide(color: AppColor.primary),
      ),
    );
  }
}