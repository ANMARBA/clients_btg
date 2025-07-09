import 'package:equatable/equatable.dart';

class Fund extends Equatable {
  final int id;
  final String name;
  final int minimum; // monto mínimo en COP
  final String category; // “FPV” o “FIC”

  const Fund({
    required this.id,
    required this.name,
    required this.minimum,
    required this.category,
  });

  @override
  List<Object> get props => [id, name, minimum, category];
}
