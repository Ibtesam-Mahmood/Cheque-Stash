
import 'package:cheque_stash/components/transactions/transaction_tile.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/transactions/edit_transaction_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  void createNewTransaction(BuildContext context) async {

    final globalStore = StoreProvider.of<GlobalState>(context);

    final newTransaction = await Navigator.of(context).to(const EditTransactionPage());
    
    if(newTransaction != null){
      globalStore.dispatch(addTransactionAction((newTransaction as Transaction).recreateWith()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add
        ),
        onPressed: (){
          createNewTransaction(context);
        },
      ),
      body: StoreConnector<GlobalState, List<Transaction>>(
        converter: (store) => store.state.transactions,
        builder: (context, transactions) {
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                pinned: true,
                floating: false,
                snap: false,
                title: Text('All Transactions'),
              ),
      
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return TransactionTile(transaction: transactions[index]);
                  },
                  childCount: transactions.length
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}