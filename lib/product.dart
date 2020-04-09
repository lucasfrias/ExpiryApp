class Product {
  final String name;
  final String imageUrl;

  Product({this.name, this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        name: json['product']['product_name'].toString(),
        imageUrl: json['product']['image_url'].toString() != null
            ? json['product']['image_thumb_url'].toString()
            : "BlankImage.png"
    );
  }
}