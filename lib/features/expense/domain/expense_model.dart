import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String expenseId;
  final String userId;
  final double amount;
  final String category;
  final String? note;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    required this.expenseId,
    required this.userId,
    required this.amount,
    required this.category,
    this.note,
    required this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'expense_id': expenseId,
      'user_id': userId,
      'amount': amount,
      'category': category,
      'note': note,
      'created_at': Timestamp.fromDate(createdAt),
      'updated_at': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map, String id) {
    return ExpenseModel(
      expenseId: id,
      userId: map['user_id'] ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? '',
      note: map['note'],
      createdAt: (map['created_at'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updated_at'] as Timestamp?)?.toDate(),
    );
  }

  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ExpenseModel.fromMap(data, doc.id);
  }
}