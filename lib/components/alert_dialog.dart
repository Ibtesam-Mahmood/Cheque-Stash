
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