import 'package:cheque_stash/components/transactions/transaction_account_card.dart';
import 'package:cheque_stash/components/transactions/transaction_date_circle.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/transactions/transactions_details_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

enum TransactionType {
  income,
  transfer,
  outgoing
}

class TransactionTile extends StatelessWidget {

  final Transaction transaction;
  final TransactionListType type;

  const TransactionTile({Key? key, required this.transaction, this.type = TransactionListType.transactions}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final transactionType = Functions.transactionType(context, transaction);

    return Card(
      child: InkWell(
        onTap: () {
          // Open transaction details
          Navigator.of(context).to(TransactionDetailsPage(transaction: transaction, type: type,));
        },
        child: Column(
          children: [

            ListTile(

              minLeadingWidth: 50,
              leading: TransactionDateCircle(
                type: type, 
                transaction: transaction
              ),

              title: Text(transaction.name),
              subtitle: Text(transaction.type),

              trailing: type == TransactionListType.projected ? StoreConnector<GlobalState, bool>(
                converter: (store) => !store.state.transactions.toMap((item) => item.id).containsKey(transaction.id),
                builder: (context, canClone){
                  return canClone ? ElevatedButton(
                    child: const Text('Clone'),
                    onPressed: (){
                      Functions.cloneProjectedTransaction(context, transaction);
                    },
                  ) : const Icon(
                    Icons.more_horiz
                  );
                }
              ) : const Icon(
                Icons.more_horiz
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  TransactionAccountCard(
                    transaction: transaction,
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

                  TransactionAccountCard(
                    to: true,
                    transaction: transaction,
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