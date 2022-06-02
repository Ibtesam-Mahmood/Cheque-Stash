
import 'package:cheque_stash/components/recurring_date_chooser.dart';
import 'package:cheque_stash/components/transactions/transaction_tile.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/transactions/edit_transaction_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({Key? key}) : super(key: key);

  void createNewBudgetTransaction(BuildContext context) async {

    final globalStore = StoreProvider.of<GlobalState>(context);

    final newTransaction = await Navigator.of(context).to(const EditTransactionPage(budgetMode: true,));
    
    if(newTransaction != null){
      globalStore.dispatch(addTransactionAction((newTransaction as Transaction).recreateWith(), inBudget: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budget'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add
        ),
        onPressed: (){
          createNewBudgetTransaction(context);
        },
      ),
      body: StoreConnector<GlobalState, List<Transaction>>(
        converter: (store) => store.state.budget,
        builder: (context, transactions) {
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return TransactionTile(transaction: transactions[index], type: TransactionListType.budget,);
            },
          );
        }
      ),
    );
  }
}