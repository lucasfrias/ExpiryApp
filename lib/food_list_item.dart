import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/food_list_provider.dart';
import 'package:provider/provider.dart';

class FoodListItem extends StatelessWidget {
  final FoodItem foodItem;

  FoodListItem({@required this.foodItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: foodItem.expired,
        onChanged: (bool checked) {
          Provider.of<FoodModel>(context, listen: false).toggleExpired(foodItem);
        },
      ),
      title: Text(foodItem.name),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onPressed: () {
          Provider.of<FoodModel>(context, listen: false).deleteFood(foodItem);
        },
      ),
    );
  }
}