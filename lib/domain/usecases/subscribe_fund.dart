import '../repositories/fund_repository.dart';

class SubscribeFund {
  final FundRepository repository;
  SubscribeFund(this.repository);

  Future<void> call(int fundId, int amount, String notifyMethod) =>
      repository.subscribe(fundId, amount, notifyMethod);
}
