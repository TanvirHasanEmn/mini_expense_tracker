import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/app_routes.dart';
import 'expense_model.dart';

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository(
    FirebaseFirestore.instance,
    FirebaseAuth.instance,
  );
});

final expensesStreamProvider = StreamProvider<List<ExpenseModel>>((ref) {
  final authUser = ref.watch(authStateChangesProvider).value;
  if (authUser == null) return Stream.value([]);

  final expenseRepo = ref.watch(expenseRepositoryProvider);
  return expenseRepo.streamExpenses();
});

class ExpenseRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ExpenseRepository(this._firestore, this._auth);

  String? get currentUserId => _auth.currentUser?.uid;

  CollectionReference _userExpensesRef(String uid) {
    return _firestore.collection('users').doc(uid).collection('expenses');
  }

  Future<void> addExpense({
    required double amount,
    required String category,
    String? note,
    required DateTime date,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");

    final docRef = _userExpensesRef(uid).doc();
    final expense = ExpenseModel(
      expenseId: docRef.id,
      userId: uid,
      amount: amount,
      category: category,
      note: note,
      createdAt: date,
    );

    await docRef.set(expense.toMap());
  }

  Stream<List<ExpenseModel>> streamExpenses() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _userExpensesRef(uid)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => ExpenseModel.fromFirestore(doc))
        .toList());
  }

  Future<void> updateExpense({
    required String expenseId,
    required double amount,
    required String category,
    String? note,
    required DateTime date,
  }) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");

    await _userExpensesRef(uid).doc(expenseId).update({
      'amount': amount,
      'category': category,
      'note': note,
      'created_at': Timestamp.fromDate(date),
      'updated_at': Timestamp.fromDate(DateTime.now()),
    });
  }

  Future<void> deleteExpense(String expenseId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception("User not authenticated");

    await _userExpensesRef(uid).doc(expenseId).delete();
  }
}