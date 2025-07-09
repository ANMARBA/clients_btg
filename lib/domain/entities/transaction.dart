import 'package:equatable/equatable.dart';

enum TransactionType { subscribe, cancel }

class Transaction extends Equatable {
  final int fundId;
  final int amount;
  final TransactionType type;
  final DateTime date;
  final String notifyMethod; // “email” o “sms”

  const Transaction({
    required this.fundId,
    required this.amount,
    required this.type,
    required this.date,
    required this.notifyMethod,
  });

  @override
  List<Object> get props => [fundId, amount, type, date, notifyMethod];
}
