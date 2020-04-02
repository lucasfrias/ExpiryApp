import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/food_list_provider.dart';

import 'food_list_item.dart';

class FoodList extends StatelessWidget {
  final List<FoodItem> foodsList;

  FoodList({@required this.foodsList});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: getChildrenTasks(),
    );
  }

  List<Widget> getChildrenTasks() {
    return foodsList.map((food) => FoodListItem(foodItem: food)).toList();
  }
}