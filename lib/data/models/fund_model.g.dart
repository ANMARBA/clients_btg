// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fund_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FundModel _$FundModelFromJson(Map<String, dynamic> json) => FundModel(
      id: (json['id'] as num).toInt(),
      name: json['nombre'] as String,
      minimum: (json['monto_minimo'] as num).toInt(),
      category: json['category'] as String,
    );

Map<String, dynamic> _$FundModelToJson(FundModel instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.name,
      'monto_minimo': instance.minimum,
      'category': instance.category,
    };
