import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasources/mock_fund_data_source.dart';
import 'data/repositories/fund_repository_impl.dart';
import 'domain/usecases/cancel_subscription.dart';
import 'domain/usecases/get_balance.dart';
import 'domain/usecases/get_funds.dart';
import 'domain/usecases/get_transaction_history.dart';
import 'domain/usecases/subscribe_fund.dart';
import 'presentation/bloc/fun/fund_bloc.dart';
import 'presentation/bloc/fun/fund_event.dart';
import 'presentation/pages/fund_list_page.dart';

void main() {
  final mockDs = MockFundDataSource();
  final repo = FundRepositoryImpl(mockDs);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final FundRepositoryImpl repo;
  const MyApp({required this.repo, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FundBloc(
        getFunds: GetFunds(repo),
        getBalance: GetBalance(repo),
        subscribe: SubscribeFund(repo),
        cancel: CancelSubscription(repo),
        getHistory: GetTransactionHistory(repo),
      )..add(LoadFunds()),
      child: MaterialApp(
        title: 'Gestión de Fondos',
        theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        debugShowCheckedModeBanner: false,
        home: const FundListPage(),
      ),
    );
  }
}
