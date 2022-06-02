
import 'package:cheque_stash/components/recurring_date_chooser.dart';
import 'package:cheque_stash/util/constants.dart';
import 'package:flutter/material.dart';

class SimpleAlertDialog {

  static AlertDialog Function(BuildContext context) build({
    required String title,
    required String description,
    Color? continueColor,
    Function()? onContinue
  }) => (context){
    return AlertDialog(
      title: Text(title),
      content: Text(description),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed:  () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text("Continue", style: TextStyle(color: continueColor),),
          onPressed:  () {
            Navigator.of(context).pop();
            onContinue?.call();
          },
        ),
      ],
    );
  };

}

class TextFieldAlertDialog {

  static Future<String?> show({
    required BuildContext context,
    required String title,
    required String description,
    String hintText = ''
  }) async {

    final controller = TextEditingController();

    return await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(description),
            const SizedBox(height: Constants.MEDIUM_PADDING,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Constants.LARGE_PADDING),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText
                ),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed:  () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Save"),
            onPressed:  () {
              Navigator.of(context).pop(controller.text.isNotEmpty ? controller.text : null);
            },
          ),
        ],
      );
    });

  }

}

class BudgetDateAlertDialog {

  static Future<DateTime?> show({
    required BuildContext context,
  }) async {

    DateTime? date;

    return await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text('Select date'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Choose a date on which to schedule this recurring transaction'),
            Padding(
              padding: const EdgeInsets.only(top: Constants.LARGE_PADDING),
              child: RecurringDateChooser(
                onChange: (newDate){
                  date = newDate;
                },
              )
            )
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed:  () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Save"),
            onPressed:  () {
              Navigator.of(context).pop(date);
            },
          ),
        ],
      );
    });

  }

}