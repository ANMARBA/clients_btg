import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/fund.dart';

part 'fund_model.g.dart';

@JsonSerializable()
class FundModel {
  final int id;
  @JsonKey(name: 'nombre')
  final String name;
  @JsonKey(name: 'monto_minimo')
  final int minimum;
  final String category;

  FundModel({
    required this.id,
    required this.name,
    required this.minimum,
    required this.category,
  });

  Fund toEntity() => Fund(
        id: id,
        name: name,
        minimum: minimum,
        category: category,
      );

  factory FundModel.fromJson(Map<String, dynamic> json) =>
      _$FundModelFromJson(json);
  Map<String, dynamic> toJson() => _$FundModelToJson(this);
}
