import '../models/transaction.dart';

abstract class TransactionRepository {
  Stream<List<Transaction>> getTransactions();
  Future<void> addTransaction(Transaction transaction);
}
