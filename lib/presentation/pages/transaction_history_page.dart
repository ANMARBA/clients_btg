import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/transaction.dart';
import '../bloc/fun/fund_bloc.dart';
import '../bloc/fun/fund_event.dart';
import '../bloc/fun/fund_state.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<FundBloc>().add(LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Transacciones'),
      ),
      body: BlocBuilder<FundBloc, FundState>(
        builder: (context, state) {
          if (state is HistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is HistoryLoaded) {
            final history = state.history;
            if (history.isEmpty) {
              return const Center(child: Text('No hay transacciones'));
            }
            return ListView.separated(
              itemCount: history.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final tx = history[index];
                return ListTile(
                  leading: Icon(
                    tx.type == TransactionType.subscribe
                        ? Icons.add_circle
                        : Icons.remove_circle,
                  ),
                  title: Text(
                    '${tx.type == TransactionType.subscribe ? 'Suscripción' : 'Cancelación'}: COP \$${tx.amount}',
                  ),
                  subtitle: Text(
                    tx.date.toLocal().toString().split('.')[0],
                  ),
                  trailing: tx.notifyMethod.isNotEmpty
                      ? Text(tx.notifyMethod.toUpperCase())
                      : null,
                );
              },
            );
          } else if (state is FundError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
