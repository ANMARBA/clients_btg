import 'package:bloc/bloc.dart';

import '../../../domain/usecases/cancel_subscription.dart';
import '../../../domain/usecases/get_balance.dart';
import '../../../domain/usecases/get_funds.dart';
import '../../../domain/usecases/get_transaction_history.dart';
import '../../../domain/usecases/subscribe_fund.dart';

import 'fund_event.dart';
import 'fund_state.dart';

class FundBloc extends Bloc<FundEvent, FundState> {
  final GetFunds _getFunds;
  final GetBalance _getBalance;
  final SubscribeFund _subscribe;
  final CancelSubscription _cancel;
  final GetTransactionHistory _getHistory;

  FundBloc({
    required GetFunds getFunds,
    required GetBalance getBalance,
    required SubscribeFund subscribe,
    required CancelSubscription cancel,
    required GetTransactionHistory getHistory,
  })  : _getFunds = getFunds,
        _getBalance = getBalance,
        _subscribe = subscribe,
        _cancel = cancel,
        _getHistory = getHistory,
        super(FundInitial()) {
    on<LoadFunds>(_onLoadFunds);
    on<SubscribeRequested>(_onSubscribe);
    on<CancelRequested>(_onCancel);
    on<LoadHistory>(_onLoadHistory);
  }

  Future<void> _onLoadFunds(LoadFunds event, Emitter<FundState> emit) async {
    emit(FundLoading());
    try {
      final funds = await _getFunds();
      final balance = await _getBalance();
      emit(FundLoaded(funds, balance));
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> _onSubscribe(
      SubscribeRequested e, Emitter<FundState> emit) async {
    emit(FundLoading());
    try {
      await _subscribe(e.fundId, e.amount, e.notifyMethod);
      add(LoadFunds()); // refrescar lista y balance
      add(LoadHistory()); // opcional: refrescar historial
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> _onCancel(CancelRequested e, Emitter<FundState> emit) async {
    emit(FundLoading());
    try {
      await _cancel(e.fundId, e.amount);
      add(LoadFunds());
      add(LoadHistory());
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }

  Future<void> _onLoadHistory(
      LoadHistory event, Emitter<FundState> emit) async {
    emit(HistoryLoading());
    try {
      final history = await _getHistory();
      emit(HistoryLoaded(history));
    } catch (e) {
      emit(FundError(e.toString()));
    }
  }
}
