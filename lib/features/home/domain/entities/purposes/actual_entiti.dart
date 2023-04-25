class ActualEntiti {
  final int id;
  final PromoDetailsEntiti promoDetailsEntiti;

  ActualEntiti({
    required this.id,
    required this.promoDetailsEntiti,
  });
}

class PromoDetailsEntiti {
  final int id;
  final String name;
  final String discription;
  final String photo;
  final DateTime? dateEnd;

  PromoDetailsEntiti({
    required this.id,
    required this.name,
    required this.discription,
    required this.photo,
    required this.dateEnd,
  });
}
