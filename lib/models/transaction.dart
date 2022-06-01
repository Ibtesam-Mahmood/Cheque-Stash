
import 'package:cheque_stash/models/account.dart';
import 'package:flutter/cupertino.dart';

class Transaction {

  final String id;
  final DateTime date;
  final double amount;
  final String name;
  final String type;
  final Account from;
  final Account to;
  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.name,
    required this.type,
    required this.from,
    required this.to,
  });

  Transaction.create({
    required this.date,
    required this.amount,
    required this.name,
    required this.type,
    required this.from,
    required this.to,
  }) : id = UniqueKey().toString();


  Transaction recreateWith({
    DateTime? date,
    double? amount,
    String? name,
    String? type,
    Account? from,
    Account? to,
  }) {
    return Transaction.create(
      date: date ?? this.date,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  Transaction copyWith({
    String? id,
    DateTime? date,
    double? amount,
    String? name,
    String? type,
    Account? from,
    Account? to,
  }) {
    return Transaction(
      id: id ?? this.id,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      name: name ?? this.name,
      type: type ?? this.type,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'amount': amount,
      'name': name,
      'type': type,
      'from': from.toJson(),
      'to': to.toJson(),
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      amount: map['amount'] as double,
      name: map['name'] as String,
      type: map['type'] as String,
      from: Account.fromJson(map['from'] as Map<String,dynamic>),
      to: Account.fromJson(map['to'] as Map<String,dynamic>),
    );
  }

  @override
  String toString() {
    return 'Transaction(id: $id, date: $date, amount: $amount, name: $name, type: $type, from: $from, to: $to)';
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
      other.from == from &&
      other.to == to;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      date.hashCode ^
      amount.hashCode ^
      name.hashCode ^
      type.hashCode ^
      from.hashCode ^
      to.hashCode;
  }
}

extension TransactionListExtension on List<Transaction>{

  List<Map<String, dynamic>> toJson() => map<Map<String, dynamic>>((a) => a.toJson()).toList();

  static List<Transaction> fromJson(List<dynamic> json) => json.map((e) => Transaction.fromJson(e)).toList(); 

  double getAccountValue(String account){
    double value = 0;
    for (var transaction in this) {
      if(transaction.to.name == account){
        // Add value
        value += transaction.amount;
      }
      if(transaction.from.name == account){
        // Remove value
        value -= transaction.amount;
      }
    }
    return value;
  }

}