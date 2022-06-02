

import 'package:cheque_stash/pages/budget/budget_page.dart';
import 'package:cheque_stash/pages/settings_page/settings_page.dart';
import 'package:cheque_stash/pages/transactions/transactions_page.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: Constants.LARGE_PADDING),
        child: ListView(
          children: [
            ListTile(
              title: const Text('Transactions', style: TextStyle(fontSize: 22),),
              onTap: (){
                //Open settings page
                Navigator.of(context).to(const TransactionsPage());
              },
            ),
            ListTile(
              title: const Text('Budget', style: TextStyle(fontSize: 22),),
              onTap: (){
                //Open settings page
                Navigator.of(context).to(const BudgetPage());
              },
            ),
            ListTile(
              title: const Text('Settings', style: TextStyle(fontSize: 22),),
              onTap: (){
                //Open settings page
                Navigator.of(context).to(const SettingsPage());
              },
            ),
          ],
        ),
      ),
    );
  }
}