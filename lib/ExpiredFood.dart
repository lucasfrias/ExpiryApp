import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
            'Expired Food',
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
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: snapshot.data[index]
                              .imageUrl != "BlankImage.png"
                              ?
                          NetworkImage(snapshot.data[index].imageUrl)
                              :
                          Image.asset('assets/images/BlankImage.png',
                              fit: BoxFit.scaleDown),
                        ),
                        title: Text(snapshot.data[index].name),
                        subtitle: Text('Expired: ' +
                            _formatISO(snapshot.data[index].expirationDate), style: TextStyle(color: Colors.red)),
                        trailing: IconButton(
                          alignment: Alignment.center,
                          icon: Icon(Icons.arrow_forward)
                        ),
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

  String _formatISO(String date){
    var datetime = DateTime.parse(date.replaceFirstMapped(RegExp("(\\.\\d{6})\\d+"), (m) => m[1]));
    return DateFormat.yMMMMd("en_US").format(datetime).toString();
  }
}