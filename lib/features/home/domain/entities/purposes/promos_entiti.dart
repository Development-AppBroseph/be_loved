class PromosEntiti {
  final int id;
  final String shortName;
  final String name;
  final String description;
  final String promo;
  final String photo;
  final DateTime? dateEnd;
  final bool availableWithoutSub;

  PromosEntiti({
    required this.id,
    required this.shortName,
    required this.name,
    required this.description,
    required this.promo,
    required this.photo,
    this.dateEnd,
    required this.availableWithoutSub,
  });
}
