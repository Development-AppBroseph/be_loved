class DetailsAnswer {
  DetailsAnswer({
    required this.details,
  });

  String details;

  factory DetailsAnswer.fromJson(Map<String, dynamic> json) => DetailsAnswer(
        details: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "detail": details,
      };
}
