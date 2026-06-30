import 'dart:async';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/transaction.dart';
import '../models/category.dart';
import '../repositories/transaction_repository.dart';

class FinanceProvider extends ChangeNotifier {
  final TransactionRepository _repository;
  List<Transaction> _transactions = [];
  List<Category> _customCategories = [];
  bool _isLoading = true;
  StreamSubscription<List<Transaction>>? _subscription;
  StreamSubscription<List<Category>>? _categoriesSubscription;

  List<Category>? _categories;

  FinanceProvider(this._repository) {
    _listenToTransactions();
    _listenToCategories();
  }

  List<Transaction> get transactions => _transactions;
  List<Category> get customCategories => _customCategories;
  bool get isLoading => _isLoading;
  
  List<Category> get categories {
    _categories ??= List.from(Category.allCategories);
    return _categories!;
  }




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

  void _listenToCategories() {
    _categoriesSubscription = _repository.getCustomCategories().listen(
      (list) {
        _customCategories = list;
        for (var cat in list) {
          Category.addCustomCategory(cat);
        }
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Error loading categories: $error");
      },
    );
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.addTransaction(transaction);
  }

  Future<void> addCategory(Category category) async {
    Category.addCustomCategory(category);
    await _repository.addCustomCategory(category);
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _categoriesSubscription?.cancel();
    super.dispose();
  }
}
