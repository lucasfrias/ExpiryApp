
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utility.dart';
import 'package:google_fonts/google_fonts.dart';

import 'DatabaseHelper.dart';
import 'GroceryItem.dart';

class GroceryList extends StatefulWidget {
  @override
  _GroceryList createState() => _GroceryList();
}

class _GroceryList extends State<GroceryList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              alignment: Alignment.center,
              iconSize: 35,
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _addGroceryItem();
                });
              },
            ),
          ],
          title: Text(
            'Grocery List',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                height: 0.3,
                color: Colors.white,
                fontWeight: FontWeight.w900,
                //fontStyle: FontStyle.italic,
                fontFamily: 'Times New Roman',
                fontSize: 35),
          ),
        ),
        body: FutureBuilder<List<GroceryItem>>(
            future: DatabaseHelper.instance.retrieveGroceryList(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length == 0) {
                  return Text(
                      "No groceries added yet! :(\nAdd some using the add button in the top right!");
                }
                else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return Card(
                          child: ListTile(
                            title: Text(snapshot.data[index].name,
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                  fontSize: 20
                              )
                            ),
                            trailing: IconButton(
                              alignment: Alignment.center,
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() async {
                                  ConfirmAction action = await Utility.asyncConfirmDialog(context, 'Delete ' + snapshot.data[index].name +
                                      ' from grocery list?');
                                  setState(() {
                                    if (action == ConfirmAction.ACCEPT) {
                                      DatabaseHelper.instance.deleteGroceryItem(snapshot.data[index].id);
                                    }
                                  });
                                });
                                },
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
        ),
        /*floatingActionButton: FloatingActionButton(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black38,
            elevation: 10.0,
            child: Icon(Icons.add),
            onPressed: () {
              setState(() {
                _addGroceryItem();
              });
            }
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation
            .endTop*/
    );
  }

  _addGroceryItem(){
    DatabaseHelper.instance.addGroceryItem(new GroceryItem(name: "Bananas" ));
  }
}
