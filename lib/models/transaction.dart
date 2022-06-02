
import 'package:cheque_stash/models/account.dart';
import 'package:flutter/cupertino.dart';

class Transaction {

  final String id;
  final DateTime date;
  final double amount;
  final String name;
  final String type;
  final String fromAccount;
  final String toAccount;
  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.name,
    required this.type,
    required this.fromAccount,
    required this.toAccount,
  });

  Transaction.create({
    required this.date,
    required this.amount,
    required this.name,
    required this.type,
    required this.fromAccount,
    required this.toAccount,
  }): id = UniqueKey().toString();


  Transaction recreateWith({
    DateTime? date,
    double? amount,
    String? name,
    String? type,
    String? fromAccount,
    String? toAccount,
  }) {
    return Transaction.create(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      type: type ?? this.type,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
    );
  }

  Transaction copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? name,
    String? type,
    String? fromAccount,
    String? toAccount,
  }) {
    return Transaction(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      type: type ?? this.type,
      fromAccount: fromAccount ?? this.fromAccount,
      toAccount: toAccount ?? this.toAccount,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'name': name,
      'type': type,
      'fromAccount': fromAccount,
      'toAccount': toAccount,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as double,
      name: map['name'] as String,
      type: map['type'] as String,
      fromAccount: map['fromAccount'] as String,
      toAccount: map['toAccount'] as String,
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, date: $date, amount: $amount, name: $name, type: $type, from: $fromAccount, to: $toAccount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Transaction &&
      other.id == id &&
      other.date == date &&
      other.amount == amount &&
      other.name == name &&
      other.type == type &&
      other.fromAccount == fromAccount &&
      other.toAccount == toAccount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      name.hashCode ^
      type.hashCode ^
      fromAccount.hashCode ^
      toAccount.hashCode;
  }
}

extension TransactionListExtension on List<Transaction>{

  List<Map<String, dynamic>> toJson() => map<Map<String, dynamic>>((a) => a.toJson()).toList();

  static List<Transaction> fromJson(List<dynamic> json) => json.map((e) => Transaction.fromJson(e)).toList();

  void dateSorted() => sort((a, b) => b.date.compareTo(a.date));

  void daySorted() => sort((a, b) => b.date.day.compareTo(a.date.day));

  Map<int, List<Transaction>> toBudgetMap(){
    final Map<int, List<Transaction>> map = {};
    for (var transaction in this) {
      if(!map.containsKey(transaction.date.day)){
        map[transaction.date.day] = [];
      }
      map[transaction.date.day]!.add(transaction);
    }
    return map;
  }

  double getAccountValue(String account){
    double value = 0;
    for (var transaction in this) {
      if(transaction.toAccount == account){
        // Add value
        value += transaction.amount;
      }
      if(transaction.fromAccount == account){
        // Remove value
        value -= transaction.amount;
      }
    }
    return value;
  }

}