import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/validators.dart';
import '../domain/add_expense_state.dart';

final addExpenseControllerProvider =
StateNotifierProvider.autoDispose<AddExpenseController, AddExpenseState>((ref) {
  return AddExpenseController();
});

class AddExpenseController extends StateNotifier<AddExpenseState> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  AddExpenseController() : super(AddExpenseState(selectedDate: DateTime.now()));

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category, categoryError: null);
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date, dateError: null);
  }

  Future<void> saveExpense() async {
    final amountText = amountController.text.trim();
    final note = noteController.text.trim();


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

    state = state.copyWith(
      isLoading: true,
      clearErrors: true,
      isSuccess: false,
    );

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