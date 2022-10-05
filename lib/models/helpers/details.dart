class DetailsAnswer {
  DetailsAnswer({
    required this.details,
  });

  String details;

  factory DetailsAnswer.fromJson(Map<String, dynamic> json, String key) =>
      DetailsAnswer(
        details: json[key],
      );

  Map<String, dynamic> toJson() => {
        "detail": details,
      };
}
