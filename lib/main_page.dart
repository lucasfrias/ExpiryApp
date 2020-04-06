import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/pantry.dart';
import 'package:http/http.dart' as http;

import 'local_notification.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
         //LocalNotificationWidget(),
       //   RandomWordsPage(),
       //   Center(
       //       child: Text("Page 3 : Grocery List Page in progress")
         // )
        ],
      ),

    );
  }
}

class RandomWordsState extends State<RandomWords> {

  Product newProduct = new Product(imageUrl: "urlExample", name: "nameExample");
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data Example'),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black38,
        elevation: 10.0,
        child: Icon(Icons.add),
        onPressed: addProduct,
      ),
    );
  }

  Future<void> addProduct() async {
    newProduct =  await fetchProduct();
    print(newProduct.name);
    print(newProduct.imageUrl);
  }

  Future<Product> fetchProduct() async {
    final response = await http.get('https://us.openfoodfacts.org/api/v0/product/737628064502');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Product.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}

class Product {
  final String name;
  final String imageUrl;

  Product({this.name, this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['product']['product_name'].toString(),
      imageUrl: json['product']['image_thumb_url'].toString() != null
        ? json['product']['image_thumb_url'].toString()
          : 'example.image'
    );
  }
}

class RandomWordsPage extends StatelessWidget {
  final  Color mainBlack = Color(0xFF383838);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: mainBlack
        ),
        home: RandomWords()
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
