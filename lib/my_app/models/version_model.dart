class VersionModel {
  final String? version;
  final bool isOnCheck;

  VersionModel({this.version, required this.isOnCheck});

  factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        version: json['version'] as String?,
        isOnCheck: json['is_on_check'] as bool,
      );
}
