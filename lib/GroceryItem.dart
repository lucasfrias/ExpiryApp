class GroceryItem {
  final int id;
  final String name;
  static const String TABLENAME = "grocery";

  GroceryItem({this.id, this.name});

  Map<String, dynamic> toMap() {
    return {'id': id,
      'name': name};
  }
}