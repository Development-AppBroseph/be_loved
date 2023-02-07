class SubscriptionVariant {
  int? overCountGb;
  int? monthLong;
  int? price;
  int? id;

  SubscriptionVariant({
    required this.overCountGb,
    required this.monthLong,
    required this.price,
    required this.id,
  });

  factory SubscriptionVariant.fromJson(Map<String, dynamic> data) {
    int? overCountGb = data['over_count_of_gb'];
    int? monthLong = data['month_long'];
    int? price = data['price'];
    int? id = data['id'];
    return SubscriptionVariant(
      overCountGb: overCountGb,
      monthLong: monthLong,
      price: price,
      id: id,
    );
  }
}
