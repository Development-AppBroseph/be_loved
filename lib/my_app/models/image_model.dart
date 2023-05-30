class ImageModel {
  final int id;
  final String name;
  final String description;
  final String date;
  final String image;

  ImageModel({
    required this.id,
    required this.name,
    required this.description,
    required this.date,
    required this.image,
  });
  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        date: json['date'] as String ,
        image: json['image'] as String,
      );
}
