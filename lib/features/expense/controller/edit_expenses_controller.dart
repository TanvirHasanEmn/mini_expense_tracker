import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../domain/edit_expenses_state.dart';

final editExpenseControllerProvider = StateNotifierProvider.autoDispose
    .family<EditExpenseController, EditExpenseState, Map<String, dynamic>>(
      (ref, initialData) {
    return EditExpenseController(initialData);
  },
);

class EditExpenseController extends StateNotifier<EditExpenseState> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  EditExpenseController(Map<String, dynamic> initialData)
      : super(
    EditExpenseState(
      expenseId: initialData['id'] ?? '',
      selectedCategory: initialData['category'],
      selectedDate: initialData['date'] is DateTime
          ? initialData['date']
          : DateTime.tryParse(initialData['date']?.toString() ?? '') ??
          DateTime.now(),
    ),
  ) {
    amountController.text = initialData['amount']?.toString() ?? '';
    noteController.text = initialData['note']?.toString() ?? '';
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category, categoryError: null);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date, dateError: null);
  }

  Future<void> updateExpense() async {
    final amountText = amountController.text.trim();

    final amountError = AppValidators.validateAmount(amountText);
    final categoryError = AppValidators.validateCategory(state.selectedCategory);
    final dateError = AppValidators.validateDate(state.selectedDate);

    if (amountError != null || categoryError != null || dateError != null) {
      state = state.copyWith(
        amountError: amountError,
        categoryError: categoryError,
        dateError: dateError,
        generalError: null,
      );
      return;
    }

    state = state.copyWith(isLoading: true, clearErrors: true, isSuccess: false);

    try {
      await Future.delayed(const Duration(milliseconds: 800));
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        generalError: e.toString(),
        isSuccess: false,
      );
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }
}