class Class {
  final String id;
  final String name;
  final String treasurer;
  final DateTime createdAt;
  final int childrenAmount;
  final bool isTreasurer;

  Class({
    required this.id,
    required this.name,
    required this.treasurer,
    required this.createdAt,
    required this.childrenAmount,
    required this.isTreasurer,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'] as String,
      name: json['name'] as String,
      treasurer: json['treasurer'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      childrenAmount: (json['childrenAmount'] ?? 0) as int,
      isTreasurer: (json['isTreasurer'] ?? false) as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'treasurer': treasurer,
      'createdAt': createdAt.toIso8601String(),
      'childrenAmount': childrenAmount,
      'isTreasurer': isTreasurer,
    };
  }

  @override
  String toString() {
    return 'Class{id: $id, name: $name, treasurer: $treasurer, createdAt: $createdAt, childrenAmount: $childrenAmount, isTreasurer: $isTreasurer}';
  }
}
