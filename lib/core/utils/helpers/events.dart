class Events {
  int? id;
  String name;
  String description;
  bool? important;
  DateTime datetime;
  bool? married;
  int? relation;
  String? image;

  Events({
    this.id,
    required this.name,
    required this.description,
    this.important,
    required this.datetime,
    this.married,
    this.image,
    this.relation,
  });

  factory Events.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    final description = json['description'];
    final important = json['important'];
    final datetime = json['datetime'];
    final married = json['married'];
    final relation = json['relation'];
    return Events(
      id: id,
      name: name,
      description: description,
      important: important,
      datetime: datetime,
      married: married,
      relation: relation,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['datetime'] = datetime;
    return data;
  }
}
