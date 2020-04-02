import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/DatabaseHelper.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'FoodItem.dart';

enum ConfirmAction { CANCEL, ACCEPT }

class Pantry extends StatefulWidget {
  @override
  _PantryState createState() => _PantryState();
}

class _PantryState extends State<Pantry>{
  @override
  void initState(){
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
                    body: FutureBuilder<List<FoodItem>>(
                      future: DatabaseHelper.instance.retrieveFoods(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: snapshot.data[index].imageUrl != "BlankImage.png" ? NetworkImage(snapshot.data[index].imageUrl) : Image.asset('assets/images/BlankImage.png', fit: BoxFit.scaleDown),
                                ),
                                title: Text(snapshot.data[index].name),
                                subtitle: Text(snapshot.data[index].expirationDate),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailScreen(),
                                      // Pass the arguments as part of the RouteSettings. The
                                      // DetailScreen reads the arguments from these settings.
                                      settings: RouteSettings(
                                        arguments: snapshot.data[index],
                                      ),
                                    ),
                                  );
                                },
                                trailing: IconButton(
                                  alignment: Alignment.center,
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    ConfirmAction action = await _asyncConfirmDialog(context);
                                    if(action == ConfirmAction.ACCEPT){
                                      DatabaseHelper.instance.deleteFood(snapshot.data[index].id);
                                    }
                                    setState(() {});
                                  },
                                ),
                              );
                            },
                          );
                        }else if(snapshot.hasError){
                          return Text("Error!" + snapshot.error.toString());
                        }
                        return CircularProgressIndicator();
                      }
                    ),
                    floatingActionButton: FloatingActionButton(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black38,
                        elevation: 10.0,
                        child: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            test();
                          });
                        }
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation
                        .endTop
                );
  }

  Future<void> test() async{
    var date = await selectDate(context);
    DatabaseHelper.instance.addFood(new FoodItem(name: "TestFood",
        imageUrl: "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
        expirationDate: DateFormat.yMMMMd("en_US").format(date).toString(),
        expired: false));
  }

 Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete food item?'),
        actions: <Widget>[
          FlatButton(
            child: const Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('ACCEPT'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
            },
          )
        ],
      );
    },
  );
}
}



/*
class _PantryState extends State<Pantry>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final foods = Provider
        .of<FoodModel>(context, listen: false)
        .allFood;

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
                    body: foods.isEmpty ? Center(
                        child: Text('No food added yet :(')) : ListView.builder(
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
                            Provider
                                .of<FoodModel>(context, listen: false)
                                .addFood(new FoodItem("TestFood",
                                "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
                                new DateTime(2020, 7, 20)));
                          });
                        }
                    ),
                    floatingActionButtonLocation: FloatingActionButtonLocation
                        .endTop
                );
  }
}
*/

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
            new Text('Expiration Date = ' + food.expirationDate)
          ],
        )
    );
  }
}
