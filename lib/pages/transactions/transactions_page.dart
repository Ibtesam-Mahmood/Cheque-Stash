
import 'package:cheque_stash/components/transactions/transaction_tile.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fort/fort.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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