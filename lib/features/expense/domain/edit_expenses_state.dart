class EditExpenseState {
  final String expenseId;
  final String? selectedCategory;
  final List<String> categories;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? amountError;
  final String? categoryError;
  final String? dateError;
  final String? generalError;
  final bool isSuccess;

  EditExpenseState({
    required this.expenseId,
    this.selectedCategory,
    this.categories = const [
      'Food & Dining',
      'Transportation',
      'Shopping',
      'Bills & Utilities',
      'Entertainment',
      'Healthcare',
      'Other',
    ],
    this.selectedDate,
    this.isLoading = false,
    this.amountError,
    this.categoryError,
    this.dateError,
    this.generalError,
    this.isSuccess = false,
  });

  EditExpenseState copyWith({
    String? expenseId,
    String? selectedCategory,
    List<String>? categories,
    DateTime? selectedDate,
    bool? isLoading,
    String? amountError,
    String? categoryError,
    String? dateError,
    String? generalError,
    bool? isSuccess,
    bool clearErrors = false,
  }) {
    return EditExpenseState(
      expenseId: expenseId ?? this.expenseId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      amountError: clearErrors ? null : (amountError ?? this.amountError),
      categoryError: clearErrors ? null : (categoryError ?? this.categoryError),
      dateError: clearErrors ? null : (dateError ?? this.dateError),
      generalError: clearErrors ? null : (generalError ?? this.generalError),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}