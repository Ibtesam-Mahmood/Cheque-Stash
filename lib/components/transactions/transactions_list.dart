

import 'package:cheque_stash/components/transactions/transaction_tile.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class TransactionsGroupedList extends StatelessWidget {

  final List<Transaction> transactions;

  final TransactionListType type;

  final DateTime Function(Transaction transaction)? groupBy;

  final String Function(DateTime date)? formatter;

  final GroupedListOrder order;

  const TransactionsGroupedList({
    Key? key, 
    required this.transactions, 
    this.groupBy,
    this.type = TransactionListType.transactions, 
    this.formatter,
    this.order = GroupedListOrder.DESC
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GroupedListView<Transaction, DateTime>(
      padding: const EdgeInsets.only(bottom: 100),
      elements: transactions,
      order: order,
      groupBy: groupBy ?? (transaction) => DateTime(transaction.date.year, transaction.date.month),
      groupSeparatorBuilder: (value) => ListTile(
        dense: true,
        title: Text(formatter?.call(value) ?? (DateFormat('MMM yyyy')).format(value))
      ),
      itemBuilder: (context, transaction) => TransactionTile(transaction: transaction, type: type,),
      groupComparator: (a, b) => a.compareTo(b),
      itemComparator: (a, b) => a.date.compareTo(b.date),
      useStickyGroupSeparators: true,
      stickyHeaderBackgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
      // floatingHeader: true,
    );
  }
}