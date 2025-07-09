import 'package:equatable/equatable.dart';

abstract class FundEvent extends Equatable {
  const FundEvent();
  @override
  List<Object?> get props => [];
}

/// Se dispara al arrancar para cargar fondos y balance
class LoadFunds extends FundEvent {}

/// Se dispara al pedir suscripción
class SubscribeRequested extends FundEvent {
  final int fundId;
  final int amount;
  final String notifyMethod;
  const SubscribeRequested(this.fundId, this.amount, this.notifyMethod);
  @override
  List<Object?> get props => [fundId, amount, notifyMethod];
}

/// Se dispara al pedir cancelación
class CancelRequested extends FundEvent {
  final int fundId;
  final int amount;
  const CancelRequested(this.fundId, this.amount);
  @override
  List<Object?> get props => [fundId, amount];
}

/// Se dispara para cargar historial
class LoadHistory extends FundEvent {}
