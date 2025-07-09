import '../repositories/fund_repository.dart';

class CancelSubscription {
  final FundRepository repository;
  CancelSubscription(this.repository);

  Future<void> call(int fundId, int amount) =>
      repository.cancel(fundId, amount);
}
