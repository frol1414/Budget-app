import 'package:cloud_firestore/cloud_firestore.dart' hide Transaction;
import '../models/transaction.dart';
import '../models/category.dart';
import 'transaction_repository.dart';

class FirestoreTransactionRepository implements TransactionRepository {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('transactions');
  final CollectionReference _categoriesCollection = FirebaseFirestore.instance.collection('categories');

  @override
  Stream<List<Transaction>> getTransactions() {
    return _collection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Transaction.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    final docRef = _collection.doc(transaction.id.isEmpty ? null : transaction.id);
    final data = transaction.toJson();
    data['id'] = docRef.id; // Store generated ID
    await docRef.set(data);
  }

  @override
  Stream<List<Category>> getCustomCategories() {
    return _categoriesCollection
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return Category.fromJson(data);
          }).toList();
        });
  }

  @override
  Future<void> addCustomCategory(Category category) async {
    final docRef = _categoriesCollection.doc(category.id.isEmpty ? null : category.id);
    final data = category.toJson();
    data['id'] = docRef.id;
    await docRef.set(data);
  }
}
