
import 'package:cheque_stash/models/account.dart';
import 'package:cheque_stash/models/transaction.dart';
import 'package:cheque_stash/state/state.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {

  late final TextEditingController controller = TextEditingController()..addListener(() {
    setState(() {
      uniqueAccount = !accountNames.contains(controller.text) && controller.text.replaceAll(' ', '').isNotEmpty;
    });
  });

  AccountType? type;

  bool yourAccount = true;

  bool uniqueAccount = false;
  double initialValue = 0.0;

  late final List<String> accountNames = StoreProvider.of<GlobalState>(context).state.accounts.map((a) => a.name).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open an Account'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(Constants.DEFAULT_PADDING),
        child: Column(
          children: [

            Expanded(
              child: ListView(
                children: [
                  const Text(
                    'Unique Account Name',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.MEDIUM_PADDING,),

                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),

                  if(yourAccount)
                    ...[
                      const SizedBox(height: Constants.LARGE_PADDING,),

                      const Text(
                        'Initial Value',
                        style: TextStyle(fontSize: 16,),
                      ),

                      const SizedBox(height: Constants.MEDIUM_PADDING,),

                      TextField(
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
                              initialValue = parsed;
                            });
                          }
                        },
                      ),
                    ],

                  const SizedBox(height: Constants.LARGE_PADDING,),

                  const Text(
                    'Account Type',
                    style: TextStyle(fontSize: 16,),
                  ),

                  const SizedBox(height: Constants.SMALL_PADDING,),

                  PopupMenuButton(
                    onSelected: (newType){
                      setState(() {
                        type = newType as AccountType;
                      });
                    },
                    child: Card(
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: Text(
                            type?.toString().replaceAll('AccountType.', '').capitalize ?? 'Select Type', 
                            style: TextStyle(fontSize: 16, fontWeight: type == null ? null : FontWeight.bold),
                          )
                        ),
                      ),
                    ),
                    itemBuilder: (context) => AccountType.values.map((e){
                      return PopupMenuItem(
                        value: e,
                        child: Text(e.toString().replaceAll('AccountType.', '').capitalize),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: Constants.LARGE_PADDING,),

                  Row(
                    children: [
                      const Text(
                        'Does the Account belong to you?',
                      ),

                      const Spacer(),

                      const Text('No'),

                      Switch(
                        value: yourAccount, 
                        onChanged: (value){
                          setState(() {
                            yourAccount = value;
                          });
                        }
                      ),

                      const Text('Yes'),
                    ],
                  ),

                ],
              ),
            ),

            const SizedBox(height: Constants.SMALL_PADDING,),

            ElevatedButton(
              onPressed: uniqueAccount && type != null && initialValue >= 0 ? (){

                final account = Account(
                  name: controller.text,
                  type: type!,
                  yours: yourAccount
                );

                //Create Account
                StoreProvider.of<GlobalState>(context).dispatch(OpenAccountEvent(account));

                //Add transaction
                if(initialValue > 0){
                  StoreProvider.of<GlobalState>(context).dispatch(addTransactionAction(Transaction.create(
                    name: 'Initial Value for ${account.name}',
                    amount: yourAccount ? initialValue : 0,
                    date: DateTime.now(),
                    fromAccount: '',
                    toAccount: account.name,
                    type: 'Initial Value'
                  )));
                }
                Navigator.of(context).pop(account);
              } : null, 
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 12),
                child: Text('Open Account', style: TextStyle(fontSize: 16),),
              )
            )

          ],
        ),
      ),
    );
  }
}