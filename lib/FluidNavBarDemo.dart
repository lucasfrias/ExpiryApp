import 'package:flutter/material.dart';
import 'package:flutter_app/ExpiredFood.dart';
import 'package:flutter_app/GroceryListScreen.dart';
import 'package:flutter_app/local_notification.dart';
import 'package:flutter_app/pantry.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'local_notification.dart';
import './fluid_nav_bar.dart';

class FluidNavBarDemo extends StatefulWidget {
  @override
  State createState() {
    return _FluidNavBarDemoState();
  }
}

class _FluidNavBarDemoState extends State {
  Widget _child;
  //final  Color mainBlack = Color(0xFF383838);

  @override
  void initState() {
    _child = Pantry();
    super.initState();
  }

  @override
  Widget build(context) {
    // Build a simple container that switches content based of off the selected navigation item
    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          appBarTheme: new AppBarTheme(color: Color(0xFF2E8B57)),
          scaffoldBackgroundColor: Colors.white70
      ),
      home: Scaffold(
        extendBody: true,
        body: _child,
        bottomNavigationBar: FluidNavBar(onChange: _handleNavigationChange),
      ),
    );
  }

  void _handleNavigationChange(int index) {
    setState(() {
      switch (index) {
        case 0:
          _child = Pantry();
          break;
        case 1:
          _child = ExpiredFood();
        //_child = LocalNotificationWidget();
          break;
        case 2:
          _child = GroceryList();
          break;
      }
      _child = AnimatedSwitcher(
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        child: _child,);
    });
  }
}