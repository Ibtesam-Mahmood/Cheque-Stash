
import 'package:flutter/material.dart';

extension DateTimeExtension on DateTime {

  String formattedDay(){
    String value = '$day';
    if(day == 1){
      value += 'st';
    }
    else if(day == 2){
      value += 'nd';
    }
    else if(day == 3){
      value += 'rd';
    }
    else{
      value += 'th';
    }
    return value;
  }

  String toBudgetDayFormat(){
    String value = formattedDay();
    if(day > 28){
      value += ' or last day';
    }
    value += ' of every month';
    return value;
  }

  /// Returns the first day of this month
  DateTime get firstDayOfMonth => isUtc ? DateTime.utc(year, month, 1) : DateTime(year, month, 1);

  /// Returns the last day of this month (considers leap years)
  DateTime get lastDayOfMonth => isUtc ? DateTime.utc(year, month + 1, 0) : DateTime(year, month + 1, 0);

}

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