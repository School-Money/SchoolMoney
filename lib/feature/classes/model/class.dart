class Class {
  final String id;
  final String name;
  final String treasurer;
  final DateTime createdAt;
  final int version;
  final int childrenAmount;
  final bool isTreasurer;

  Class({
    required this.id,
    required this.name,
    required this.treasurer,
    required this.createdAt,
    required this.version,
    required this.childrenAmount,
    required this.isTreasurer,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      id: json['_id'] as String,
      name: json['name'] as String,
      treasurer: json['treasurer'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      version: json['__v'] as int,
      childrenAmount: json['childrenAmount'] as int,
      isTreasurer: json['isTreasurer'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'treasurer': treasurer,
      'createdAt': createdAt.toIso8601String(),
      '__v': version,
      'childrenAmount': childrenAmount,
      'isTreasurer': isTreasurer,
    };
  }

  @override
  String toString() {
    return 'Class{id: $id, name: $name, treasurer: $treasurer, createdAt: $createdAt, version: $version, childrenAmount: $childrenAmount, isTreasurer: $isTreasurer}';
  }
}
