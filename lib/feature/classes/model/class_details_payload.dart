class ClassDetailsPayload {
  final String name;

  ClassDetailsPayload({required this.name});

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  factory ClassDetailsPayload.fromJson(Map<String, dynamic> json) {
    return ClassDetailsPayload(
      name: json['name'],
    );
  }
}
