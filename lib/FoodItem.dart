class FoodItem {
  final int id;
  final String name;
  final String imageUrl;
  final String expirationDate;
  bool expired;
  static const String TABLENAME = "foods";

  FoodItem({this.id, this.name, this.imageUrl, this.expirationDate, this.expired});

  Map<String, dynamic> toMap() {
    return {'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'expirationDate': expirationDate,
      'expired': expired ? 1 : 0};
  }

  void toggleExpired() {
    expired = !expired;
  }
}