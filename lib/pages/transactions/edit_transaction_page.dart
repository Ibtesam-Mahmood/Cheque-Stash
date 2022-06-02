
import 'package:cheque_stash/components/alert_dialog.dart';
import 'package:cheque_stash/models/account.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/pages/home_page/create_account_page.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:cheque_stash/util/extensions.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';
import 'package:intl/intl.dart';

class EditTransactionPage extends StatefulWidget {

  final Transaction? transaction;
  final bool budgetMode;

  const EditTransactionPage({Key? key, this.transaction, this.budgetMode = false}) : super(key: key);

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {

  late String name = widget.transaction?.name ?? '';
  late String? type = widget.transaction?.type;
  late double amount = widget.transaction?.amount ?? 0.0;
  late String accountFrom = widget.transaction?.fromAccount ?? '';
  late String accountTo = widget.transaction?.toAccount ?? '';
  late DateTime? date = widget.transaction?.date ?? (widget.budgetMode ? null : DateTime.now());

  bool get canSave => name.isNotEmpty &&
    type != null &&
    amount > 0 &&
    (accountFrom.isNotEmpty == true || accountTo.isNotEmpty == true) &&
    accountFrom != accountTo &&
    date != null;

  void Function(String value) accountSelectorCallBack([bool to = false]) => (String newType) async {
    if(newType.isNotEmpty){
      // Set account
      setState(() {
        if(to){  
          accountTo = newType;
        }
        else{
          accountFrom = newType;
        }
      });
    }
    else{
      // Create new account
      final newAccount = await Navigator.of(context).to(const CreateAccountPage());

      if(newAccount is Account){
        // Set account
        setState(() {
          if(to){  
            accountTo = newAccount.name;
          }
          else{
            accountFrom = newAccount.name;
          }
        });
      }
    }
  };

  void Function(String value) typeSelectorCallBack(List<String> types) => (String newType) async {
    if(newType.isNotEmpty){
      // Set type
      setState(() {
        type = newType;
      });
    }
    else{
      // Create new type
      final createdType = await TextFieldAlertDialog.show(
        context: context, 
        title: 'Create new Type', 
        description: 'Types are used to categorize your transactions.',
        hintText: 'Type name'
      );

      if(createdType != null){
        //Create saved type
        // ignore: use_build_context_synchronously
        StoreProvider.of<GlobalState>(context).dispatch(AddSavedTypeEvent(createdType));

        // Set type
        setState(() {
          type = createdType;
        });
      }
    }
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.transaction == null ? 'Create' : 'Edit'} ${widget.budgetMode ? 'Budget' : 'Transaction'}'),
        actions: [
          if(widget.transaction != null)
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: (){
                // Send request to delete transaction and close page after confirming
                showDialog(context: context, builder: SimpleAlertDialog.build(
                  title: 'Delete Transaction', 
                  description: 'Are you sure you want to delete this transaction, it will reflect in your account value and expected value.',
                  continueColor: Theme.of(context).colorScheme.error,
                  onContinue: (){
                    //Delete transaction
                    StoreProvider.of<GlobalState>(context).dispatch(deleteTransactionAction(widget.transaction!, inBudget: widget.budgetMode));
                    Navigator.of(context).pop();
                  }
                ));
              },
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
        child: Column(
          children: [

            Expanded(
              child: ListView(
                children: [

/*
 
                     _   _                      
                    | \ | | __ _ _ __ ___   ___ 
                    |  \| |/ _` | '_ ` _ \ / _ \
                    | |\  | (_| | | | | | |  __/
                    |_| \_|\__,_|_| |_| |_|\___|
                                                
 
*/

                  const Text(
                    'Name',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.MEDIUM_PADDING,),

                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      hintText: 'Transaction Name'
                    ),
                    onChanged: (value){
                      setState(() {
                        name = value;
                      });
                    },
                  ),

/*
 
                        _                                _   
                       / \   _ __ ___   ___  _   _ _ __ | |_ 
                      / _ \ | '_ ` _ \ / _ \| | | | '_ \| __|
                     / ___ \| | | | | | (_) | |_| | | | | |_ 
                    /_/   \_\_| |_| |_|\___/ \__,_|_| |_|\__|
                                                             
 
*/

                  const SizedBox(height: Constants.LARGE_PADDING,),

                  const Text(
                    'Amount',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.MEDIUM_PADDING,),

                  TextFormField(
                    initialValue: amount > 0 ? amount.toString() : null,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      hintText: '0.0',
                      prefixIcon: Icon(
                        Icons.monetization_on_outlined,
                      )
                    ),
                    onChanged: (value){
                      double? parsed = double.tryParse(value.replaceAll(' ', ''));
                      if(parsed != null){
                        setState(() {
                          amount = parsed;
                        });
                      }
                    },
                  ),

/*
 
                     _____                    
                    |  ___| __ ___  _ __ ___  
                    | |_ | '__/ _ \| '_ ` _ \ 
                    |  _|| | | (_) | | | | | |
                    |_|  |_|  \___/|_| |_| |_|
                                              
 
*/

                  const SizedBox(height: Constants.LARGE_PADDING,),

                  const Text(
                    'From:',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.SMALL_PADDING,),

                  StoreConnector<GlobalState, List<Account>>(
                    converter: (store) => store.state.accounts,
                    builder: (context, accounts) {
                      
                      final options = [...accounts.map((e) => e.name), ''];

                      return PopupMenuButton(
                        onSelected: accountSelectorCallBack(),
                        child: Card(
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                accountFrom.isNotEmpty ? accountFrom.capitalize : 'Select Account', 
                                style: TextStyle(fontSize: 16, fontWeight: accountFrom.isEmpty ? null : FontWeight.bold),
                              )
                            ),
                          ),
                        ),
                        itemBuilder: (context) => options.map((e){
                          return PopupMenuItem(
                            value: e,
                            child: Text(e.isNotEmpty ? e.capitalize : 'Create New Account'),
                          );
                        }).toList(),
                      );
                    }
                  ),

/*
 
                     _____     
                    |_   _|__  
                      | |/ _ \ 
                      | | (_) |
                      |_|\___/ 
                               
 
*/

                  const SizedBox(height: Constants.LARGE_PADDING,),

                  const Text(
                    'To:',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.SMALL_PADDING,),

                  StoreConnector<GlobalState, List<Account>>(
                    converter: (store) => store.state.accounts,
                    builder: (context, accounts) {

                      final options = [...accounts.map((e) => e.name), ''];
                      
                      return PopupMenuButton(
                        onSelected: accountSelectorCallBack(true),
                        child: Card(
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                accountTo.isNotEmpty ? accountTo.capitalize : 'Select Account', 
                                style: TextStyle(fontSize: 16, fontWeight: accountTo.isEmpty ? null : FontWeight.bold),
                              )
                            ),
                          ),
                        ),
                        itemBuilder: (context) => options.map((e){
                          return PopupMenuItem(
                            value: e,
                            child: Text(e.isNotEmpty ? e.capitalize : 'Create New Account'),
                          );
                        }).toList(),
                      );
                    }
                  ),

/*
 
                     ____        _       
                    |  _ \  __ _| |_ ___ 
                    | | | |/ _` | __/ _ \
                    | |_| | (_| | ||  __/
                    |____/ \__,_|\__\___|
                                         
 
*/

                  
                  const SizedBox(height: Constants.LARGE_PADDING,),

                  const Text(
                    'Date',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.SMALL_PADDING,),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Constants.LARGE_PADDING),
                    child: ElevatedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          date == null ? 'Select Day' : (
                            widget.budgetMode ? date!.toBudgetDayFormat() : DateFormat('EEE MMM dd, yyyy').format(date!)
                          ),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: () async {
                        final newDate = widget.budgetMode ? await BudgetDateAlertDialog.show(context: context) : await showDatePicker(
                          context: context,
                          initialDate: date!,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2050),
                          helpText: "Select Transaction Date",
                          cancelText: "CANCEL",
                          confirmText: "SAVE"
                        );
                        setState(() {
                          date = newDate ?? date;
                        });
                      }, 
                    ),
                  ),

                  
/*
 
                     _____                 
                    |_   _|   _ _ __   ___ 
                      | || | | | '_ \ / _ \
                      | || |_| | |_) |  __/
                      |_| \__, | .__/ \___|
                          |___/|_|         
 
*/

                  const SizedBox(height: Constants.LARGE_PADDING,),

                  const Text(
                    'Type',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.MEDIUM_PADDING,),

                  StoreConnector<GlobalState, List<String>>(
                    converter: (store) => store.state.savedTypes,
                    builder: (context, allTypes) {
                      return PopupMenuButton(
                        onSelected: typeSelectorCallBack(allTypes),
                        child: Card(
                          child: Container(
                            width: 200,
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                type?.capitalize ?? 'Transaction Type', 
                                style: TextStyle(fontSize: 16, fontWeight: type == null ? null : FontWeight.bold),
                              )
                            ),
                          ),
                        ),
                        itemBuilder: (context) => [...allTypes, ''].map((e){
                          return PopupMenuItem(
                            value: e,
                            child: Text(e.isNotEmpty ? e.capitalize : 'Create New Type'),
                          );
                        }).toList(),
                      );
                    }
                  ),

                  const SizedBox(height: Constants.LARGE_PADDING * 3,),
                ],
              ),
            ),

/*
 
               ____                  
              / ___|  __ ___   _____ 
              \___ \ / _` \ \ / / _ \
               ___) | (_| |\ V /  __/
              |____/ \__,_| \_/ \___|
                                     
 
*/

            const SizedBox(height: Constants.SMALL_PADDING,),

            ElevatedButton(
              onPressed: canSave ? (){

                // Returns a transaction with no ID
                final Transaction transaction = Transaction(
                  id: widget.transaction?.id ?? '', 
                  date: date!, 
                  amount: amount, 
                  name: name, 
                  type: type!, 
                  fromAccount: accountFrom, 
                  toAccount: accountTo
                );

                Navigator.of(context).pop(transaction);

              } : null, 
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                child: Text('Save', style: TextStyle(fontSize: 16),),
              )
            )

          ],
        ),
      ),
    );
  }
}