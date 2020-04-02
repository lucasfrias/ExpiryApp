import 'package:flutter/material.dart';
import 'package:flutter_app/FluidNavBarDemo.dart';
import 'package:provider/provider.dart';

import 'food_list_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final  Color mainBlack = Color(0xFF383838);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FoodModel(),
      child: MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: mainBlack
        ),
        home: FluidNavBarDemo()
      ),
    );
  }
}