import 'package:flutter/material.dart';
import 'package:flutter_app/FoodItemsScreen.dart';
import 'package:flutter_app/Scanner.dart';

class MainPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          FoodItemsScreen(),
          Center(
            child: Text("Page 2 : Expired Items Page in progress"),
          ),
          Center(
            child: Text("Page 3 : Grocery List Page in progress")
          )
        ],
      ),

    );
  }
}
