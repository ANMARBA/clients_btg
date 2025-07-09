import '../entities/fund.dart';
import '../entities/transaction.dart';

abstract class FundRepository {
  Future<List<Fund>> getFunds();
  Future<int> getBalance();
  Future<void> subscribe(int fundId, int amount, String notifyMethod);
  Future<void> cancel(int fundId, int amount);
  Future<List<Transaction>> getHistory();
}
