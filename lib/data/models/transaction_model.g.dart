// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      fundId: (json['fondo_id'] as num).toInt(),
      amount: (json['amount'] as num).toInt(),
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      notifyMethod: json['notify'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'fondo_id': instance.fundId,
      'amount': instance.amount,
      'type': instance.type,
      'date': instance.date.toIso8601String(),
      'notify': instance.notifyMethod,
    };
