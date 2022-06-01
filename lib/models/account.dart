

enum AccountType{
  checking,
  saving,
  bill,
  person,
  other
}

class Account {
  
  final String name;
  final AccountType type;
  final bool yours;
  
  Account({
    required this.name,
    required this.type,
    required this.yours,
  });

  factory Account.empty() => Account(
    name: '',
    type: AccountType.other,
    yours: true,
  );

  Account copyWith({
    String? name,
    AccountType? type,
    bool? yours,
  }) {
    return Account(
      name: name ?? this.name,
      type: type ?? this.type,
      yours: yours ?? this.yours,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type.index,
      'yours': yours,
    };
  }

  factory Account.fromJson(Map<String, dynamic> map) {
    return Account(
      name: map['name'] as String,
      type: AccountType.values[map['type']],
      yours: map['yours'] as bool,
    );
  }

  @override
  String toString() => 'Account(name: $name, type: $type, yours: $yours)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Account &&
      other.name == name &&
      other.type == type &&
      other.yours == yours;
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode ^ yours.hashCode;
}

extension AccountListExtension on List<Account>{

  List<Map<String, dynamic>> toJson() => map<Map<String, dynamic>>((a) => a.toJson()).toList();

  static List<Account> fromJson(List<dynamic> json) => json.map((e) => Account.fromJson(e)).toList(); 

}