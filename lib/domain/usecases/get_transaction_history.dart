import '../entities/transaction.dart';
import '../repositories/fund_repository.dart';

class GetTransactionHistory {
  final FundRepository repository;
  GetTransactionHistory(this.repository);

  Future<List<Transaction>> call() => repository.getHistory();
}
