class CollectionClass {
  final String name;

  CollectionClass({required this.name});

  factory CollectionClass.fromJson(Map<String, dynamic> json) {
    return CollectionClass(
      name: json['name'] as String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}