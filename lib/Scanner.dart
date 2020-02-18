import 'dart:async';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class Scanner extends StatefulWidget {
  @override
  _ScanState createState() => new _ScanState();
}

class _ScanState extends State<Scanner> {
  final Color mainBlack = Color(0xFF383838);
  String barcode = "";
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark, scaffoldBackgroundColor: mainBlack),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('Scan Barcode'),
              backgroundColor: mainBlack,
            ),
            body: new Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                  ),
                  new Text("Barcode Number after Scan : " + barcode),
                  // displayImage(),
                ],
              ),
            ),
        ));
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
