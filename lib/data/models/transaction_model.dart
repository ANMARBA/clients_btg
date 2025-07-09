import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/transaction.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  @JsonKey(name: 'fondo_id')
  final int fundId;
  final int amount;
  // usaremos strings “subscribe” / “cancel” en JSON
  final String type;
  final DateTime date;
  @JsonKey(name: 'notify')
  final String notifyMethod;

  TransactionModel({
    required this.fundId,
    required this.amount,
    required this.type,
    required this.date,
    required this.notifyMethod,
  });

  Transaction toEntity() => Transaction(
        fundId: fundId,
        amount: amount,
        type: type == 'subscribe'
            ? TransactionType.subscribe
            : TransactionType.cancel,
        date: date,
        notifyMethod: notifyMethod,
      );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
