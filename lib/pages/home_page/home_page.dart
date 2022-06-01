import 'package:cheque_stash/components/home_page/account_card.dart';
import 'package:cheque_stash/models/account.dart';
import 'package:cheque_stash/pages/home_page/create_account_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:cheque_stash/components/home_page/main_drawer.dart';
import 'package:fort/fort.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budge-8'),
      ),
      drawer: const MainDrawer(),
      body: StoreConnector<GlobalState, List<Account>>(
        converter: (store) => store.state.accounts,
        builder: (context, accounts) {
          return SingleChildScrollView(
            child: Wrap(
              children: accounts.map((account){
                return AccountCard(account: account);
              }).toList(),
            ),
          );
        }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Open Account', style: TextStyle(fontWeight: FontWeight.bold),),
        onPressed: (){
          Navigator.of(context).to(const CreateAccountPage());
        },
      ),
    );
  }
}