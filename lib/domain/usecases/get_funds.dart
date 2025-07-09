import '../entities/fund.dart';
import '../repositories/fund_repository.dart';

class GetFunds {
  final FundRepository repository;
  GetFunds(this.repository);

  Future<List<Fund>> call() => repository.getFunds();
}
