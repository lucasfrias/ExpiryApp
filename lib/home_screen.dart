import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'food_list_provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text(
                'Pantry',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Open Sans',
                    fontSize: 40),
              ),
            ),

            floatingActionButton: FloatingActionButton(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black38,
                elevation: 10.0,
                child: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    Provider.of<FoodModel>(context, listen: false).addFood(new FoodItem("TestFood", "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg", new DateTime(2020, 7, 20)));
                    Navigator.pop(context);
                  });
                }
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop
        );
  }
}

/*class Pantry extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter setState) =>
          MaterialApp(
              theme: ThemeData(
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Color(0xFF383838)
              ),
              home: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Pantry',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Open Sans',
                          fontSize: 40),
                    ),
                  ),
                  body: foods.isEmpty ? Center(child: Text('No food added yet :(')) : ListView.builder(
                    itemCount: foods.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(foods[index].name),
                        // When a user taps the ListTile, navigate to the DetailScreen.
                        // Notice that you're not only creating a DetailScreen, you're
                        // also passing the current todo through to it.
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(),
                              // Pass the arguments as part of the RouteSettings. The
                              // DetailScreen reads the arguments from these settings.
                              settings: RouteSettings(
                                arguments: foods[index],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                  floatingActionButton: FloatingActionButton(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.black38,
                      elevation: 10.0,
                      child: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          //addProduct(context);
                          foods.add(new FoodItem("TestFood", "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg", new DateTime(2020, 7, 20)));
                        });
                      }
                  ),
                  floatingActionButtonLocation: FloatingActionButtonLocation.endTop
              )
          )
    );
  }*/

 Future<void> addProduct(BuildContext context) async {
    try {
      var barcode = await barcodeScanning();
      // ignore: null_aware_in_logical_operator
      if(barcode?.isNotEmpty && barcode != null){
        var expirationDate = await selectDate(context);
        if(expirationDate != null){
          var product = await fetchProduct(barcode);
          if(product != null){
            //foods.add(FoodItem(product.name, product.imageUrl, expirationDate));
            print("Successfully added item!");
          }
          else{
            print("Product response from API was null!");
          }
        }
      }
      return null;
    }catch(e){
      print(e.toString());
    }
  }

  Future<String> barcodeScanning() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#004297", "Cancel", true, ScanMode.BARCODE);
      return barcode != null ? barcode : null;
    } on PlatformException catch (e) {
      throw Exception('Unknown error: $e');
    } on FormatException {
      throw Exception('Nothing captured.');
    } catch (e) {
      throw Exception('Unknown error: $e');
    }
  }

  Future<DateTime> selectDate(BuildContext context) async {
    final DateTime today = DateTime.now();
    final DateTime expirationDate =  await showDatePicker(
        context: context,
        initialDate: today,
        firstDate: today,
        lastDate: DateTime.now().add(Duration(days: 356))
    );

    return expirationDate != null ? expirationDate : null;
  }

  Future<Product> fetchProduct(String barcode) async {
    final response = await http.get('https://us.openfoodfacts.org/api/v0/product/' + barcode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, then parse the JSON.
      return Product.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response, then throw an exception.
      throw Exception('Failed to load album');
    }
  }

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

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FoodItem food = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
      ),
      body: new ListView(
        children: <Widget>[
          food.imageUrl != "BlankImage.png" ? Image.network(food.imageUrl, fit: BoxFit.scaleDown) : Image.asset('assets/images/BlankImage.png', fit: BoxFit.scaleDown),
          new Text('Expiration Date = ' + DateFormat.yMMMMd("en_US").format(food.expirationDate).toString())
        ],
      )
    );
  }
}