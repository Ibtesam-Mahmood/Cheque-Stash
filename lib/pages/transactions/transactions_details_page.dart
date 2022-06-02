

import 'package:cheque_stash/components/alert_dialog.dart';
import 'package:cheque_stash/components/transactions/transaction_account_card.dart';
import 'package:cheque_stash/components/transactions/transaction_date_circle.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/transactions/edit_transaction_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class TransactionDetailsPage extends StatelessWidget {

  final Transaction transaction;
  final TransactionListType type;

  const TransactionDetailsPage({Key? key, required this.transaction, required this.type}) : super(key: key);

  void _editTransaction(context) async {

    final globalStore = StoreProvider.of<GlobalState>(context);

    //Open transaction page
    final newTransaction = await Navigator.of(context).to(EditTransactionPage(transaction: transaction, mode: type,));

    if(newTransaction != null && newTransaction != transaction){
      // Edit transaction
      globalStore.dispatch(EditTransactionEvent(
        transaction: (newTransaction as Transaction).recreateWith(),
        destination: type
      ));
    }
  }

  void _deleteTransaction(context){
    // Send request to delete transaction and close page after confirming
    showDialog(context: context, builder: SimpleAlertDialog.build(
      title: 'Delete Transaction', 
      description: 'Are you sure you want to delete this transaction, it will reflect in your account value and expected value.',
      continueColor: Theme.of(context).colorScheme.error,
      onContinue: (){
        //Delete transaction
        StoreProvider.of<GlobalState>(context).dispatch(DeleteTransactionEvent(
          transactionID: transaction.id,
          destination: type
        ));
        Navigator.of(context).pop();
      }
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [

          SliverAppBar(
            title: const Text('Details'),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit
                ),
                onPressed: () => _editTransaction(context),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.error,
                ),
                onPressed: () => _deleteTransaction(context),
              )
            ],
          ),
          
          SliverPadding(
            padding: const EdgeInsets.only(top: Constants.LARGE_PADDING),
            sliver: SliverToBoxAdapter(
              child: TransactionDateCircle(
                size: 100,
                type: type, 
                transaction: transaction,
              ),
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(Constants.MEDIUM_PADDING),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Text(
                  transaction.name,
                  style: const TextStyle(fontSize: 36),
                ),
              )
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.only(bottom: Constants.MEDIUM_PADDING),
            sliver: SliverToBoxAdapter(
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Constants.SMALL_PADDING, horizontal: Constants.MEDIUM_PADDING),
                    child: Text(
                      transaction.type,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              )
            ),
          ),
          
          SliverPadding(
            padding: const EdgeInsets.all(Constants.MEDIUM_PADDING),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Expanded(
                    child: TransactionAccountCard(
                      height: null,
                      width: null,
                      transaction: transaction,
                    ),
                  ),

                  const SizedBox(width: Constants.MEDIUM_PADDING,),

                  Column(
                    children: [
                      Text(
                        '\$ ${transaction.amount}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward,
                        size: 32,
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: Constants.MEDIUM_PADDING,),

                  Expanded(
                    child: TransactionAccountCard(
                      to: true,
                      height: null,
                      width: null,
                      transaction: transaction,
                    ),
                  ),

                ],
              ),
            ),
          ),

        ],
      ),
      floatingActionButton: type == TransactionListType.projected ? StoreConnector<GlobalState, bool>(
        converter: (store) => !store.state.transactions.toMap((item) => item.id).containsKey(transaction.id),
        builder: (context, canClone){
          return canClone ? FloatingActionButton.extended(
            label: const Text('Clone'),
            onPressed: (){
              Functions.cloneProjectedTransaction(context, transaction);
            },
          ) : const SizedBox.shrink();
        }
      ) : null,
    );
  }
}