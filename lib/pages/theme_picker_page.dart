
import 'package:cheque_stash/state/state.dart';
import 'package:flutter/material.dart';
import 'package:fort/fort.dart';

class ThemePickerPage extends StatelessWidget {
  const ThemePickerPage({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {

    final globalStore = StoreProvider.of<GlobalState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Selector'),
      ),
      body: Container(),
    );
  }
}