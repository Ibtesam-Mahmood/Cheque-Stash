import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/transactions/edit_transaction_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fort/fort.dart';
import 'package:intl/intl.dart';

enum TransactionType {
  income,
  transfer,
  outgoing
}

class TransactionTile extends StatelessWidget {

  final Transaction transaction;

  const TransactionTile({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final type = Functions.transactionType(context, transaction);

    return Card(
      child: InkWell(
        onTap: () async {

          final globalStore = StoreProvider.of<GlobalState>(context);

          //Open transaction page
          final newTransaction = await Navigator.of(context).to(EditTransactionPage(transaction: transaction,));

          if(newTransaction != null && newTransaction != transaction){
            // Edit transaction
            globalStore.dispatch(editTransactionAction(newTransaction));
          }
        },
        child: Column(
          children: [

            ListTile(

              minLeadingWidth: 50,
              leading: Container(
                height: 50,
                width: 50,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Functions.transactionTypeColor(context, type),
                    width: 2
                  )
                ),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    DateFormat('MMM dd\nyyyy').format(transaction.date),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              title: Text(transaction.name),
              subtitle: Text(transaction.type),

              trailing: const Icon(
                Icons.more_horiz
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Container(
                    height: 50,
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: Constants.DEFAULT_RADIUS,
                      border: Border.all(
                        color: Functions.transactionTypeColor(context, type),
                        width: 0.5
                      )
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        transaction.fromAccount,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const SizedBox(width: Constants.MEDIUM_PADDING,),

                  Column(
                    children: [
                      Text(
                        '\$ ${transaction.amount}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: Constants.MEDIUM_PADDING,),

                  Container(
                    height: 50,
                    width: 100,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: Constants.DEFAULT_RADIUS,
                      color: Functions.transactionTypeColor(context, type)
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        transaction.toAccount,
                        style: TextStyle(fontSize: 18, color: Functions.onTransactionTypeColor(context, type), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}