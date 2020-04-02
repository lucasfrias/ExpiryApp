import 'package:flutter/cupertino.dart';
import 'dart:collection';
import 'package:flutter/material.dart';

class FoodModel extends ChangeNotifier{
  final List<FoodItem> _foods = [];

  List<FoodItem> get allFood => UnmodifiableListView(_foods);
  List<FoodItem> get expiredFood => UnmodifiableListView(_foods.where((food) => food.expired));

  void addFood(FoodItem food) {
    _foods.add(food);
    notifyListeners();
  }

  void toggleExpired(FoodItem food) {
    final foodIndex = _foods.indexOf(food);
    _foods[foodIndex].toggleExpired();
    notifyListeners();
  }

  void deleteFood(FoodItem food) {
    _foods.remove(food);
    notifyListeners();
  }
}

class FoodItem {
  String name;
  String imageUrl;
  DateTime expirationDate;
  bool expired;

  FoodItem(this.name, this.imageUrl, this.expirationDate, {this.expired = false});

  void toggleExpired(){
    expired = !expired;
  }
}