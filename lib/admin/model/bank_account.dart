class BankAccount {
  final String id;
  final String accountNumber;
  final double balance;
  final String owner;

  BankAccount({
    required this.id,
    required this.accountNumber,
    required this.balance,
    required this.owner,
  });

  // Factory method to create an instance of BankAccount from JSON
  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      id: json['_id'] as String,
      accountNumber: json['accountNumber'] as String,
      balance: (json['balance'] as num).toDouble(),
      owner: json['owner'] as String,
    );
  }

  // Convert BankAccount instance to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'accountNumber': accountNumber,
      'balance': balance,
      'owner': owner,
    };
  }

  // toString method for easy debugging
  @override
  String toString() {
    return 'BankAccount(id: $id, accountNumber: $accountNumber, balance: $balance, owner: $owner)';
  }
}
