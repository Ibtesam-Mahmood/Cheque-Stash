
import 'package:flutter/material.dart';

extension NavigatorStateExtension on NavigatorState {

  Future<void> to(Widget page) => push(MaterialPageRoute(
    builder: (context) => page,
  ));

}