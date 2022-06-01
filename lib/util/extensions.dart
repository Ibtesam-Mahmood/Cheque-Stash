
import 'package:flutter/material.dart';

extension NavigatorStateExtension on NavigatorState {

  Future<dynamic> to(Widget page) => push(MaterialPageRoute(
    builder: (context) => page,
  ));

}

extension ListExtension<T> on List<T> {

  Map<S, T> toMap<S>(S Function(T item) accessor) {
    final Map<S, T> map = {};
    for (var element in this) {
      map[accessor(element)] = element;
    }
    return map;
  }
}