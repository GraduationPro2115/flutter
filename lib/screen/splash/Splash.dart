import 'dart:async';

import 'package:doct_app/screen/theme/Color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../home/Home.dart';
import '../utils/app_preferences.dart';
import '../utils/global.dart';
import 'package:intl/date_symbol_data_local.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late AppPreferences _preferences;

  bool userLogin = false;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _preferences = AppPreferences();
    userData();

    Timer(
      const Duration(seconds: 2),
      () => Navigator.of(context).pushAndRemoveUntil(
          PageTransition(
              type: PageTransitionType.bottomToTop,
              duration: Duration(seconds: 1),
              alignment: Alignment.center,
              child: Home()),
          (Route<dynamic> route) => false),
    );

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_launcher');
    var initialzationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initialzationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             color: Colors.blue,
    //             // TODO add a proper drawable resource to android, for now using
    //             //      one that already exists in example app.
    //             icon: "@mipmap/ic_launcher",
    //           ),
    //         ));
    //   }
    // });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      AppleNotification? apple = message.notification?.apple;
      if (notification != null && android != null) {
        if (android.imageUrl.toString() != '' &&
            android.imageUrl.toString() != 'null') {
          http.get(Uri.parse(android.imageUrl.toString())).then((response) {
            flutterLocalNotificationsPlugin.show(
                notification.hashCode,
                notification.title,
                notification.body,
                NotificationDetails(
                  android: AndroidNotificationDetails(channel.id, channel.name,
                      channelDescription: channel.description,
                      styleInformation: BigPictureStyleInformation(
                        ByteArrayAndroidBitmap(response.bodyBytes),
                      ),
                      channelAction: AndroidNotificationChannelAction.update,
                      enableVibration: true,
                      playSound: true,
                      icon: '@mipmap/ic_launcher'),
                ));
          });
        } else {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(channel.id, channel.name,
                    channelDescription: channel.description,
                    channelAction: AndroidNotificationChannelAction.update,
                    enableVibration: true,
                    playSound: true,
                    icon: '@mipmap/ic_launcher'),
              ));
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {}
    });
  }

  userData() async {
    userLogin = await _preferences.getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 150,
              height: 150,
            ),
            const Text(
              APP_NAME,
              style: TextStyle(
                fontSize: 30,
                color: ColorsInt.colorBlack,
                fontWeight: FontWeight.w700,
                fontFamily: "Inter",
              ),
            )
          ],
        ),
      ),
    );
  }
}
