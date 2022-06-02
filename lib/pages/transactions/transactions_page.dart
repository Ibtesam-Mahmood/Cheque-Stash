
import 'package:cheque_stash/components/transactions/transaction_tile.dart';
import 'package:cheque_stash/components/transactions/transactions_list.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/transactions/edit_transaction_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> with SingleTickerProviderStateMixin {

  late final TabController controller = TabController(length: 2, vsync: this);

  void createNewTransaction(BuildContext context) async {

    final globalStore = StoreProvider.of<GlobalState>(context);
    final type = controller.index == 1 ? TransactionListType.projected : TransactionListType.transactions;

    final newTransaction = await Navigator.of(context).to(EditTransactionPage(mode: type,));
    
    if(newTransaction != null){
      globalStore.dispatch(AddTransactionEvent(
        transaction: (newTransaction as Transaction).recreateWith(),
        destination: type
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Transactions'),
        bottom: TabBar(
          controller: controller,
          tabs: const [
            Tab(child: Text('Budgeted'),),
            Tab(child: Text('Transactions'),),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add
        ),
        onPressed: (){
          createNewTransaction(context);
        },
      ),
      body: TabBarView(
        controller: controller,
        children: [
          StoreConnector<GlobalState, List<Transaction>>(
            converter: (store) => store.state.projectedTransactions,
            builder: (context, transactions) {
              return TransactionsGroupedList(
                type: TransactionListType.projected,
                transactions: transactions,
              );
            }
          ),
          StoreConnector<GlobalState, List<Transaction>>(
            converter: (store) => store.state.transactions,
            builder: (context, transactions) {
              return TransactionsGroupedList(
                transactions: transactions,
              );
            }
          ),
        ],
      ),
    );
  }
}