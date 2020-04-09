import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/GroceryItem.dart';
import 'package:flutter_app/utility.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DatabaseHelper.dart';
import 'FoodItem.dart';

class ExpiredFood extends StatefulWidget {
  @override
  _ExpiredFoodState createState() => _ExpiredFoodState();
}

class _ExpiredFoodState extends State<ExpiredFood> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Expired',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                height: 0.3,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                //fontStyle: FontStyle.italic,
                fontFamily: 'Times New Roman',
                fontSize: 40)
          ),
        ),
        body: FutureBuilder<List<FoodItem>>(
            future: DatabaseHelper.instance.retrieveExpiredFoods(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Text(
                      "No food has expired yet, whew!");
                }
                else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
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
                              fontSize: 18)
                        ),
                        subtitle: Text("Expired " +
                            DateTime.now().difference(DateTime.parse(snapshot.data[index].expirationDate)).inDays.toString()
                            + " day(s) ago",
                            style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 13,
                                color: Colors.redAccent)),
                            /*style: GoogleFonts.permanentMarker(
                                textStyle: TextStyle(),
                                color: Colors.redAccent)),*/
                        trailing: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () async {
                            ConfirmAction action = await Utility.asyncConfirmDialog(context,
                                'Move ' + snapshot.data[index].name + ' to grocery list?');
                            setState(() {
                              if (action == ConfirmAction.ACCEPT) {
                                DatabaseHelper.instance.addGroceryItem(new GroceryItem(name: snapshot.data[index].name));
                                DatabaseHelper.instance.deleteFood(snapshot.data[index].id);
                              }
                            });
                          }
                        ),
                      )
                      );
                    },
                  );
                }
              } else if (snapshot.hasError) {
                return Text("Error!" + snapshot.error.toString());
              }
              return CircularProgressIndicator();
            }
        )
    );
  }
}