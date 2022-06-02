
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionDateCircle extends StatelessWidget {

  
  const TransactionDateCircle({
    Key? key,
    this.size = 50,
    required this.type,
    required this.transaction,
  }) : super(key: key);

  final TransactionListType type;
  final Transaction transaction;
  final double size;

  @override
  Widget build(BuildContext context) {

    final transactionType = Functions.transactionType(context, transaction);

    return Container(
      height: size,
      width: size,
      padding: EdgeInsets.all(size/5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Functions.transactionTypeColor(context, transactionType),
          width: size*2/50
        )
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          type == TransactionListType.budget ? transaction.date.formattedDay() : DateFormat('MMM dd\nyyyy').format(transaction.date),
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}