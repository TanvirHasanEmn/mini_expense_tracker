class HomeState {
  final String userName;
  final double monthlyExpense;
  final double totalExpense;
  final bool isLoading;

  const HomeState({
    this.userName = 'User',
    this.monthlyExpense = 0.0,
    this.totalExpense = 0.0,
    this.isLoading = false,
  });

  HomeState copyWith({
    String? userName,
    double? monthlyExpense,
    double? totalExpense,
    bool? isLoading,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      monthlyExpense: monthlyExpense ?? this.monthlyExpense,
      totalExpense: totalExpense ?? this.totalExpense,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}