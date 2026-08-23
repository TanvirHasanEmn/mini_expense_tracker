import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../expense/domain/expense_model.dart';
import '../../expense/domain/expense_repo.dart';
import '../domain/home_state.dart';

final homeControllerProvider =
StateNotifierProvider.autoDispose<HomeController, HomeState>((ref) {
  final expensesAsync = ref.watch(expensesStreamProvider);
  return HomeController(expensesAsync);
});

class HomeController extends StateNotifier<HomeState> {
  final AsyncValue<List<ExpenseModel>> _expensesAsync;

  HomeController(this._expensesAsync) : super(const HomeState()) {
    _fetchUserName();
    _calculateSummaries();
  }

  Future<void> _fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        final name = userDoc.data()?['name'] as String? ?? 'User';
        state = state.copyWith(userName: name);
      }
    } catch (_) {}
  }

  void _calculateSummaries() {
    _expensesAsync.whenData((expenses) {
      final now = DateTime.now();
      final total = expenses.fold<double>(
        0.0,
            (sum, item) => sum + item.amount,
      );

      final monthly = expenses
          .where((item) =>
      item.createdAt.month == now.month &&
          item.createdAt.year == now.year)
          .fold<double>(
        0.0,
            (sum, item) => sum + item.amount,
      );

      state = state.copyWith(
        totalExpense: total,
        monthlyExpense: monthly,
      );
    });
  }
}