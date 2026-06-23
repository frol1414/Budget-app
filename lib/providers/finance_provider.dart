import 'dart:async';
import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../repositories/transaction_repository.dart';

class FinanceProvider extends ChangeNotifier {
  final TransactionRepository _repository;
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  StreamSubscription<List<Transaction>>? _subscription;

  FinanceProvider(this._repository) {
    _listenToTransactions();
  }

  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  void _listenToTransactions() {
    _isLoading = true;
    notifyListeners();

    _subscription = _repository.getTransactions().listen(
      (list) {
        _transactions = list;
        _isLoading = false;
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Error loading transactions: $error");
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
