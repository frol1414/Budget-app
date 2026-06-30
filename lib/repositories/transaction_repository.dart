import '../models/transaction.dart';
import '../models/category.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> getTransactions();
  Future<void> addTransaction(Transaction transaction);
  
  Stream<List<Category>> getCustomCategories();
  Future<void> addCustomCategory(Category category);
}
