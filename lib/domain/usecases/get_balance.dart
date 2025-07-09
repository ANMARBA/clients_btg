import '../repositories/fund_repository.dart';

class GetBalance {
  final FundRepository repository;
  GetBalance(this.repository);

  Future<int> call() => repository.getBalance();
}
