import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class FoodItemsScreen extends StatefulWidget {
  @override
  _Pantry createState() => new _Pantry();
}

class _Pantry extends State<FoodItemsScreen> {

  //example of 20 random foods
  List<FoodItem> foods = List.generate(
    20,
        (i) => FoodItem(
      'Food Item $i',
      'A description of food item $i',
    ),
  );

  String barcode = "";

  @override
  initState() {
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
      body: ListView.builder(
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
          onPressed: barcodeScanning,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop
    );
  }

  Future barcodeScanning() async {
    try {
      String barcode = await FlutterBarcodeScanner.scanBarcode(
          "#004297", "Cancel", true, ScanMode.BARCODE);
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    } on FormatException {
      setState(() => this.barcode = 'Nothing captured.');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
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
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(food.description),
      ),
    );
  }
}

class FoodItem {
  final String name;
  final String description;

  FoodItem(this.name, this.description);
}