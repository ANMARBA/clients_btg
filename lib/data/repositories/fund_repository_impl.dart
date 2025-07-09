import '../../domain/entities/fund.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/fund_repository.dart';
import '../datasources/mock_fund_data_source.dart';

class FundRepositoryImpl implements FundRepository {
  final MockFundDataSource _ds;
  FundRepositoryImpl(this._ds);

  @override
  Future<List<Fund>> getFunds() async {
    final models = await _ds.fetchFunds();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<int> getBalance() => _ds.fetchBalance();

  @override
  Future<void> subscribe(int fundId, int amount, String notifyMethod) =>
      _ds.doSubscribe(fundId, amount, notifyMethod);

  @override
  Future<void> cancel(int fundId, int amount) => _ds.doCancel(fundId, amount);

  @override
  Future<List<Transaction>> getHistory() async {
    final models = await _ds.fetchHistory();
    return models.map((m) => m.toEntity()).toList();
  }
}
