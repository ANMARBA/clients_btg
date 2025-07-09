import '../models/fund_model.dart';
import '../models/transaction_model.dart';

class MockFundDataSource {
  final List<FundModel> _funds = [
    FundModel(
        id: 1,
        name: 'FPV_BTG_PACTUAL_RECAUDADORA',
        minimum: 75000,
        category: 'FPV'),
    FundModel(
        id: 2,
        name: 'FPV_BTG_PACTUAL_ECOPETROL',
        minimum: 125000,
        category: 'FPV'),
    FundModel(id: 3, name: 'DEUDAPRIVADA', minimum: 50000, category: 'FIC'),
    FundModel(id: 4, name: 'FDO-ACCIONES', minimum: 250000, category: 'FIC'),
    FundModel(
        id: 5,
        name: 'FPV_BTG_PACTUAL_DINAMICA',
        minimum: 100000,
        category: 'FPV'),
  ];

  int _balance = 500000; // saldo inicial COP

  final List<TransactionModel> _history = [];

  Future<List<FundModel>> fetchFunds() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_funds);
  }

  Future<int> fetchBalance() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _balance;
  }

  Future<void> doSubscribe(int fundId, int amount, String notify) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final fund = _funds.firstWhere((f) => f.id == fundId);
    if (amount < fund.minimum) {
      throw Exception('Monto mínimo: ${fund.minimum}');
    }
    if (amount > _balance) {
      throw Exception('Saldo insuficiente');
    }
    _balance -= amount;
    _history.add(TransactionModel(
      fundId: fundId,
      amount: amount,
      type: 'subscribe',
      date: DateTime.now(),
      notifyMethod: notify,
    ));
  }

  Future<void> doCancel(int fundId, int amount) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _balance += amount;
    _history.add(TransactionModel(
      fundId: fundId,
      amount: amount,
      type: 'cancel',
      date: DateTime.now(),
      notifyMethod: '',
    ));
  }

  Future<List<TransactionModel>> fetchHistory() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_history);
  }
}
