

// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:cheque_stash/components/transactions/transaction_tile.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class Constants {

  static const double SMALL_PADDING = 8;
  static const double MEDIUM_PADDING = 16;
  static const double DEFAULT_PADDING = 24;
  static const double LARGE_PADDING = 32;

  static Duration get DEFAULT_DURATION => const Duration(milliseconds: 200);

  static Curve get DEFAULT_CURVE => Curves.easeInOutCubic;

  static BorderRadius get DEFAULT_RADIUS => BorderRadius.circular(16);
  static BorderRadius get SQUARE_RADIUS => BorderRadius.circular(8);

}

class Functions {

  static TransactionType transactionType(BuildContext context, Transaction transaction){

    final accountMap = StoreProvider.of<GlobalState>(context).state.accounts.toMap<String>((a) => a.name);
    
    if(accountMap[transaction.toAccount]?.yours == true){
      // In bound transaction
      if(accountMap[transaction.fromAccount]?.yours == true) {
        // Transfer in between accounts
        return TransactionType.transfer;
      }
      else{
        // Income
        return TransactionType.income;
      }
    }
    else{
      // Out bound transaction
      return TransactionType.outgoing;
    }
  }

  static Color transactionTypeColor(BuildContext context, TransactionType type){
    final theme = Theme.of(context).colorScheme;
    switch (type) {
      case TransactionType.income:
        return theme.primaryContainer;
      case TransactionType.transfer:
        return theme.secondaryContainer;
      default: // outgoing
        return theme.errorContainer;
    }
  }

  static Color onTransactionTypeColor(BuildContext context, TransactionType type){
    final theme = Theme.of(context).colorScheme;
    switch (type) {
      case TransactionType.income:
        return theme.onPrimaryContainer;
      case TransactionType.transfer:
        return theme.onSecondaryContainer;
      default: // outgoing
        return theme.onErrorContainer;
    }
  }

}