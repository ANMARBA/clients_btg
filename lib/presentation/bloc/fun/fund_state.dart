import 'package:equatable/equatable.dart';

import '../../../domain/entities/fund.dart';
import '../../../domain/entities/transaction.dart';

abstract class FundState extends Equatable {
  const FundState();
  @override
  List<Object?> get props => [];
}

class FundInitial extends FundState {}

class FundLoading extends FundState {}

class FundLoaded extends FundState {
  final List<Fund> funds;
  final int balance;
  const FundLoaded(this.funds, this.balance);
  @override
  List<Object?> get props => [funds, balance];
}

class FundError extends FundState {
  final String message;
  const FundError(this.message);
  @override
  List<Object?> get props => [message];
}

class HistoryLoading extends FundState {}

class HistoryLoaded extends FundState {
  final List<Transaction> history;
  const HistoryLoaded(this.history);
  @override
  List<Object?> get props => [history];
}
