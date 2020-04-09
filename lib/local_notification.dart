
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/FluidNavBarDemo.dart';
import 'package:flutter_app/pantry.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notfication_helper.dart';
class LocalNotification {
/*class LocalNotificationWidget extends StatefulWidget {
  @override
  _LocalNotificationWidgetState createState() =>
      _LocalNotificationWidgetState();
}

class _LocalNotificationWidgetState extends State<LocalNotificationWidget> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FluidNavBarDemo()),
  );

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: ListView(
      children: <Widget>[
        title('Basics'),
        RaisedButton(
          child: Text('Show notification'),
          onPressed: () => _showNotification()
        ),
        RaisedButton(
            child: Text('Schedule notification'),
            onPressed: () => _scheduleNotification()
        ),
        RaisedButton(
          child: Text('Cancel all notification'),
          onPressed: flutterLocalNotificationsPlugin.cancelAll,
        ),
      ],
    ),
  );

  Widget title(String text) => Container(
    margin: EdgeInsets.symmetric(vertical: 4),
    child: Text(
      text,
      style: Theme.of(context).textTheme.title,
      textAlign: TextAlign.center,
    ),
  );*/

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  BuildContext context;

  LocalNotification(){
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async =>
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FluidNavBarDemo()),
      );

  void showNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
        0, 'plain title', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }

  //Scheduling may or may not be be implemented. Problem occurs is food item is scheduled them deleted. Do not know if
  //there is a way to delete a specific notification. There is a cancel all notifications option but then i would constantly
  //create be checking if a food item was deleted and re-creating the scheduled notification.
  scheduleNotification(String foodName, DateTime date) async {
    //TODO: change to 7 days
    var scheduledNotificationDateTime = date.subtract(new Duration(days: 1));
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your other channel id',
        'your other channel name', 'your other channel description');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        'Hey you have food about to expire!',
        '$foodName will expire in 7 days.',
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  cancelAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll;
  }
}