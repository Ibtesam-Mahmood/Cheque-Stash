

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
  
  Account({
    required this.name,
    required this.type,
  });

  factory Account.empty() => Account(
    name: '',
    type: AccountType.other
  );

  Account copyWith({
    String? name,
    AccountType? type,
  }) {
    return Account(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'type': type.index,
    };
  }

  factory Account.fromJson(Map<String, dynamic> map) {
    return Account(
      name: map['name'] as String,
      type: AccountType.values[map['type']],
    );
  }

  @override
  String toString() => 'Account(name: $name, type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Account &&
      other.name == name &&
      other.type == type;
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode;
}

extension AccountListExtension on List<Account>{

  List<Map<String, dynamic>> toJson() => map<Map<String, dynamic>>((a) => a.toJson()).toList();

  static List<Account> fromJson(List<dynamic> json) => json.map((e) => Account.fromJson(e)).toList(); 

}