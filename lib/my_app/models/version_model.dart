class VersionModel {
  final String? version;

  VersionModel({this.version});

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        version: json['version'] as String?,
      );
}
