
import 'package:cheque_stash/models/account.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class AccountCard extends StatelessWidget {

  final Account account;

  const AccountCard({Key? key, required this.account}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context).colorScheme;

    return Card(
      color: account.yours ? theme.secondaryContainer : theme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(Constants.MEDIUM_PADDING),
        child: Column(
          children: [
            Text(account.name, style: TextStyle(fontSize: 24, color: account.yours ? theme.onSecondaryContainer : theme.onErrorContainer,),),
            const SizedBox(height: 20,),
            StoreConnector<GlobalState, double>(
              distinct: true,
              converter: (store) => store.state.transactions.getAccountValue(account.name),
              builder: (context, value) {
                return Text('\$ $value', style: TextStyle(
                  color: account.yours ? theme.onSecondaryContainer : theme.onErrorContainer,
                  fontSize: 36, 
                  fontWeight: FontWeight.bold
                ),);
              }
            )
          ],
        ),
      ),
    );
  }
}