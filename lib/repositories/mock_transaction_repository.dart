import 'dart:async';
import '../models/category.dart';
import '../models/transaction.dart';
import 'transaction_repository.dart';

class MockTransactionRepository implements TransactionRepository {
  final List<Transaction> _list = [
    // June 23, 2026
    Transaction(
      id: '1',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 15.40,
      date: DateTime(2026, 6, 23, 14, 30),
    ),
    Transaction(
      id: '2',
      category: Category.getById('transport'),
      type: TransactionType.expense,
      amount: 4.50,
      date: DateTime(2026, 6, 23, 10, 15),
    ),
    Transaction(
      id: '3',
      category: Category.getById('salary'),
      type: TransactionType.income,
      amount: 2500.00,
      date: DateTime(2026, 6, 23, 9, 00),
    ),
    
    // June 22, 2026
    Transaction(
      id: '4',
      category: Category.getById('entertainment'),
      type: TransactionType.expense,
      amount: 25.00,
      date: DateTime(2026, 6, 22, 19, 45),
    ),
    Transaction(
      id: '5',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 42.10,
      date: DateTime(2026, 6, 22, 13, 00),
    ),
    Transaction(
      id: '6',
      category: Category.getById('freelance'),
      type: TransactionType.income,
      amount: 150.00,
      date: DateTime(2026, 6, 22, 11, 20),
    ),
    
    // June 21, 2026
    Transaction(
      id: '7',
      category: Category.getById('utilities'),
      type: TransactionType.expense,
      amount: 85.50,
      date: DateTime(2026, 6, 21, 15, 30),
    ),
    Transaction(
      id: '8',
      category: Category.getById('shopping'),
      type: TransactionType.expense,
      amount: 120.00,
      date: DateTime(2026, 6, 21, 11, 00),
    ),

    // June 20, 2026
    Transaction(
      id: '9',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 8.50,
      date: DateTime(2026, 6, 20, 18, 10),
    ),
    Transaction(
      id: '10',
      category: Category.getById('transport'),
      type: TransactionType.expense,
      amount: 2.75,
      date: DateTime(2026, 6, 20, 8, 30),
    ),

    // June 19, 2026
    Transaction(
      id: '11',
      category: Category.getById('investment'),
      type: TransactionType.income,
      amount: 50.00,
      date: DateTime(2026, 6, 19, 14, 00),
    ),
    Transaction(
      id: '12',
      category: Category.getById('entertainment'),
      type: TransactionType.expense,
      amount: 15.00,
      date: DateTime(2026, 6, 19, 20, 00),
    ),

    // June 18, 2026
    Transaction(
      id: '13',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 34.20,
      date: DateTime(2026, 6, 18, 12, 45),
    ),
    Transaction(
      id: '14',
      category: Category.getById('transport'),
      type: TransactionType.expense,
      amount: 5.50,
      date: DateTime(2026, 6, 18, 9, 15),
    ),

    // June 17, 2026
    Transaction(
      id: '15',
      category: Category.getById('shopping'),
      type: TransactionType.expense,
      amount: 45.00,
      date: DateTime(2026, 6, 17, 16, 20),
    ),

    // June 16, 2026
    Transaction(
      id: '16',
      category: Category.getById('freelance'),
      type: TransactionType.income,
      amount: 300.00,
      date: DateTime(2026, 6, 16, 10, 00),
    ),
    Transaction(
      id: '17',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 12.90,
      date: DateTime(2026, 6, 16, 19, 30),
    ),

    // June 15, 2026
    Transaction(
      id: '18',
      category: Category.getById('utilities'),
      type: TransactionType.expense,
      amount: 60.00,
      date: DateTime(2026, 6, 15, 14, 00),
    ),

    // June 14, 2026
    Transaction(
      id: '19',
      category: Category.getById('entertainment'),
      type: TransactionType.expense,
      amount: 9.99,
      date: DateTime(2026, 6, 14, 21, 15),
    ),
    Transaction(
      id: '20',
      category: Category.getById('food'),
      type: TransactionType.expense,
      amount: 22.40,
      date: DateTime(2026, 6, 14, 13, 10),
    ),
  ];

  final StreamController<List<Transaction>> _controller = StreamController<List<Transaction>>.broadcast();

  @override
  Stream<List<Transaction>> getTransactions() {
    final controller = StreamController<List<Transaction>>();
    // Emit initial list.
    controller.add(List.unmodifiable(_list));

    // Listen to changes and forward.
    final subscription = _controller.stream.listen((updatedList) {
      if (!controller.isClosed) {
        controller.add(updatedList);
      }
    });

    controller.onCancel = () {
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    // Add to the list. Keep it sorted by date descending.
    _list.insert(0, transaction);
    _list.sort((a, b) => b.date.compareTo(a.date));
    _controller.add(List.unmodifiable(_list));
  }

  final List<Category> _customCategories = [];
  final StreamController<List<Category>> _categoryController = StreamController<List<Category>>.broadcast();

  @override
  Stream<List<Category>> getCustomCategories() {
    final controller = StreamController<List<Category>>();
    // Emit initial list.
    controller.add(List.unmodifiable(_customCategories));

    // Listen to changes and forward.
    final subscription = _categoryController.stream.listen((updatedList) {
      if (!controller.isClosed) {
        controller.add(updatedList);
      }
    });

    controller.onCancel = () {
      subscription.cancel();
      controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> addCustomCategory(Category category) async {
    if (!_customCategories.any((c) => c.id == category.id)) {
      _customCategories.add(category);
      _categoryController.add(List.unmodifiable(_customCategories));
    }
  }
}
