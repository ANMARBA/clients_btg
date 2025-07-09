import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/fund.dart';
import '../bloc/fun/fund_bloc.dart';
import '../bloc/fun/fund_event.dart';
import '../bloc/fun/fund_state.dart';

import 'transaction_history_page.dart';

class FundListPage extends StatelessWidget {
  const FundListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Fondos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                builder: (_) => const TransactionHistoryPage(),
              ))
                  .then((_) {
                // Al volver, recarga los fondos
                context.read<FundBloc>().add(LoadFunds());
              });
            },
          ),
        ],
      ),
      body: BlocListener<FundBloc, FundState>(
        listener: (context, state) {
          if (state is FundError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is FundLoaded && state is! FundLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Datos actualizados')),
            );
          }
        },
        child: BlocBuilder<FundBloc, FundState>(
          buildWhen: (prev, curr) =>
              curr is FundLoading || curr is FundLoaded || curr is FundError,
          builder: (context, state) {
            if (state is FundLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FundLoaded) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Saldo actual: COP \$${state.balance}',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<FundBloc>().add(LoadFunds());
                      },
                      child: ListView.builder(
                        itemCount: state.funds.length,
                        itemBuilder: (context, index) {
                          final fund = state.funds[index];
                          return _FundItem(fund: fund);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else if (state is FundError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _FundItem extends StatelessWidget {
  final Fund fund;
  const _FundItem({required this.fund});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fund.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Mínimo: COP \$${fund.minimum}  •  ${fund.category}'),
                ],
              ),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _showSubscribeDialog(context, fund),
                  child: const Text('Suscribir'),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () => _showCancelDialog(context, fund),
                  child: const Text('Cancelar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscribeDialog(BuildContext context, Fund fund) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();
    String notifyMethod = 'email';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Suscribirse a ${fund.name}'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
                validator: (value) {
                  final val = int.tryParse(value ?? '');
                  if (val == null) return 'Ingresa un número válido';
                  if (val < fund.minimum)
                    return 'Monto mínimo: ${fund.minimum}';
                  final balance =
                      (context.read<FundBloc>().state as FundLoaded).balance;
                  if (val > balance) return 'Saldo insuficiente';
                  return null;
                },
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: notifyMethod,
                items: const [
                  DropdownMenuItem(value: 'email', child: Text('Email')),
                  DropdownMenuItem(value: 'sms', child: Text('SMS')),
                ],
                onChanged: (v) => notifyMethod = v!,
                decoration: const InputDecoration(labelText: 'Notificación'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final amount = int.parse(amountCtrl.text);
                context.read<FundBloc>().add(
                      SubscribeRequested(fund.id, amount, notifyMethod),
                    );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Fund fund) {
    final formKey = GlobalKey<FormState>();
    final amountCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Cancelar participación en ${fund.name}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Monto a cancelar'),
            validator: (v) {
              final val = int.tryParse(v ?? '');
              if (val == null || val <= 0) return 'Ingresa un monto válido';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final amt = int.parse(amountCtrl.text);
                context.read<FundBloc>().add(CancelRequested(fund.id, amt));
                Navigator.pop(context);
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}
