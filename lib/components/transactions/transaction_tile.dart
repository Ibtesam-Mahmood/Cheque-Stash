import 'package:cheque_stash/models/transaction.dart';
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
  
  TransactionType transactionType(BuildContext context){

    final accountMap = StoreProvider.of<GlobalState>(context).state.accounts.toMap<String>((a) => a.name);
    
    if(accountMap[transaction.toAccount]?.yours == true){
      // In bound transaction
      if(accountMap[transaction.fromAccount]?.yours == true) {
        // Transfer in between accounts
        return TransactionType.transfer;
      }
      else{
        // Income
        return TransactionType.income;
      }
    }
    else{
      // Out bound transaction
      return TransactionType.outgoing;
    }
  }

  Color transactionTypeColor(BuildContext context, TransactionType type){
    final theme = Theme.of(context).colorScheme;
    switch (type) {
      case TransactionType.income:
        return theme.primary;
      case TransactionType.transfer:
        return theme.secondary;
      default: // outgoing
        return theme.error;
    }
  }

  @override
  Widget build(BuildContext context) {

    final type = transactionType(context);

    return Card(
      child: InkWell(
        onTap: (){
          //Open account page
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
                    color: transactionTypeColor(context, type),
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

              trailing: IconButton(
                icon: const Icon(
                  Icons.more_horiz
                ),
                onPressed: (){
                  // Open edit sheet
                },
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
                        color: transactionTypeColor(context, type),
                        width: 0.5
                      )
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        transaction.fromAccount,
                        style: const TextStyle(fontSize: 18),
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
                      color: transactionTypeColor(context, type)
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        transaction.toAccount,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),

                  // Text(
                  //   transaction.toAccount.isEmpty ? 'Void' : transaction.toAccount,
                  //   style: TextStyle(fontSize: 18),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}