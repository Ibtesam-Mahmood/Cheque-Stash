import 'package:cheque_stash/models/account.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

part 'event.dart';
part 'reducer.dart';

class GlobalState extends FortState<GlobalState>{

  final int themeFlexScheme;

  final ThemeMode themeMode;

  final List<Account> accounts;

  final List<Transaction> budget;

  final List<Transaction> transactions;

  final List<Transaction> projectedTransactions;

  final List<String> savedTypes;

  final DateTime startDate;

  GlobalState({
    required this.themeFlexScheme,
    required this.themeMode,
    required this.accounts,
    required this.budget,
    required this.transactions,
    required this.projectedTransactions,
    required this.savedTypes,
    required this.startDate,
  });

  factory GlobalState.initial() => GlobalState(
    themeFlexScheme: 0,
    themeMode: ThemeMode.system,
    startDate: DateTime.now(),
    savedTypes: ['Initial Value'],
    accounts: [],
    budget: [],
    transactions: [],
    projectedTransactions: [],
  );

  factory GlobalState.fromJson(dynamic json){
    return GlobalState(
      themeFlexScheme: json['themeFlexScheme'],
      themeMode: ThemeMode.values[json['themeMode']],
      savedTypes: json['savedTypes'],
      accounts: AccountListExtension.fromJson(json['accounts']),
      budget: TransactionListExtension.fromJson(json['budget']),
      transactions: TransactionListExtension.fromJson(json['transactions']),
      projectedTransactions: TransactionListExtension.fromJson(json['projectedTransactions']),
      startDate: DateTime.fromMillisecondsSinceEpoch(json['startDate'] as int),
    );
  }

  @override
  dynamic toJson() => {
    'themeFlexScheme': themeFlexScheme,
    'themeMode': themeMode.index,
    'savedTypes': savedTypes,
    'accounts': accounts.toJson(),
    'budget': budget.toJson(),
    'transactions': transactions.toJson(),
    'projectedTransactions': projectedTransactions.toJson(),
    'startDate': startDate.microsecondsSinceEpoch,
  };

  @override
  FortState<GlobalState> copyWith(FortState<GlobalState> other) {
    return other;
  }

  static Tower<GlobalState> get tower => Tower<GlobalState>(
    _stateReducer,
    initialState: GlobalState.initial(),
    serializer: GlobalState.fromJson
  );

}