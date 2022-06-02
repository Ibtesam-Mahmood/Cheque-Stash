
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:flutter/material.dart';

class TransactionAccountCard extends StatelessWidget {

  final double? height;
  final double? width;

  final Transaction transaction;
  final bool to;

  const TransactionAccountCard({
    Key? key, 
    required this.transaction, 
    this.to = false,
    this.height = 50,
    this.width = 100
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final transactionType = Functions.transactionType(context, transaction);

    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: Constants.DEFAULT_RADIUS,
        color: to ? Functions.transactionTypeColor(context, transactionType) : null,
        border: to ? null : Border.all(
          color: Functions.transactionTypeColor(context, transactionType),
          width: 0.5
        )
      ),
      child: FittedBox(
        fit: BoxFit.contain,
        child: Text(
          to ? transaction.toAccount : transaction.fromAccount,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}