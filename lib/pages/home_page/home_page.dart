import 'package:flutter/material.dart';
import 'package:cheque_stash/components/home_page/main_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budge-8'),
      ),
      drawer: MainDrawer(),
    );
  }
}