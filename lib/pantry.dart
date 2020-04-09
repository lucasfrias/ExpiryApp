import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/DatabaseHelper.dart';
import 'package:flutter_app/product.dart';
import 'package:flutter_app/utility.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'FoodItem.dart';
import 'local_notification.dart';

class Pantry extends StatefulWidget {
  @override
  _PantryState createState() => _PantryState();
}

class _PantryState extends State<Pantry>{
  LocalNotification localNotifications;

  @override
  void initState(){
    localNotifications = new LocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Pantry',
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          height: 0.3,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            //fontStyle: FontStyle.italic,
                            fontFamily: 'Times New Roman',
                            fontSize: 40),
                      ),
                    ),
                    body: FutureBuilder<List<FoodItem>>(
                      future: DatabaseHelper.instance.retrieveNonExpiredFoods(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          if(snapshot.data.length == 0){
                            return Text("No food added yet! :(\nAdd some using the add button in the top right!");
                          }
                          else {
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Dismissible(
                                    direction: DismissDirection.endToStart,
                                    key: UniqueKey(),
                                    onDismissed: (direction) {
                                      _deleteFood(context, snapshot.data[index].id, snapshot.data[index].name);
                                    },
                                    background: Container(
                                       // padding: EdgeInsets.only(right: 10),
                                        //alignment: AlignmentDirectional.centerEnd,
                                        color: Colors.redAccent,
                                        child: Icon(Icons.delete_forever, color: Colors.white)
                                    ),
                                child: Card(
                                  color: Colors.white,
                                    child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: snapshot.data[index]
                                        .imageUrl != "BlankImage.png"
                                        ?
                                    NetworkImage(snapshot.data[index].imageUrl)
                                        :
                                    Image.asset('assets/images/BlankImage.png',
                                        fit: BoxFit.scaleDown),
                                  ),
                                  title: Text(snapshot.data[index].name,
                                        style: TextStyle(
                                      fontFamily: 'Times New Roman',
                                        fontSize: 18),
                                        ),
                                  subtitle: Text('Expires: ' +
                                      Utility.formatISO(snapshot.data[index].expirationDate),
                                      style: TextStyle(
                                        fontFamily: 'Times New Roman',
                                        fontSize: 13)
                                  ),
                                  /*onTap: () {
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
                                  },*/
                                    )
                                )
                                );
                              },
                            );
                          }
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
    //var date = await selectDate(context);
    setState(() {
      /*DatabaseHelper.instance.addFood(new FoodItem(name: "TestFood",
          imageUrl: "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
          expirationDate: DateFormat.yMMMMd("en_US").format(date).toString(),
          expired: false));*/
      DatabaseHelper.instance.addFood(new FoodItem(name: "Milk",
          imageUrl: "https://static.openfoodfacts.org/images/products/073/762/806/4502/front_en.6.100.jpg",
          expirationDate: new DateTime.now().subtract(new Duration(days: 1)).toIso8601String(),
          //date.toIso8601String(),
          expired: false));
    });
    //localNotifications.scheduleNotification("TestFood", date);
  }

  Future<void> addProduct() async {
    try {
      var barcode = await barcodeScanning();
      // ignore: null_aware_in_logical_operator
      if(barcode?.isNotEmpty && barcode != null){
        var expirationDate = await selectDate(context);
        if(expirationDate != null){
          var product = await fetchProduct(barcode);
          if(product != null){
            setState(() {
              DatabaseHelper.instance.addFood(new FoodItem(name: product.name,
                  imageUrl: product.imageUrl,
                  expirationDate: Utility.formatISO(expirationDate.toIso8601String()),
                  expired: false));
            });
            localNotifications.scheduleNotification(product.name, expirationDate);
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

  _deleteFood(BuildContext context, int id, String name) async{
    ConfirmAction action = await Utility.asyncConfirmDialog(context, 'Delete $name from pantry?');
    setState(() {
      if (action == ConfirmAction.ACCEPT) {
        DatabaseHelper.instance.deleteFood(id);
      }
    });
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


/*class DetailScreen extends StatelessWidget {
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
}*/
