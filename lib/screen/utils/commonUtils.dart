import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../theme/Color.dart';

class CommonUtils {
  static var httpClient = new HttpClient();

  showDailog(context) {
    Future.delayed(Duration.zero, () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.transparent,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        "assets/images/logo.png",
                        height: 60.0,
                        width: 60.0,
                      ),
                      Container(
                        height: 100.0,
                        width: 100.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorsInt.colorPrimary1),
                          backgroundColor:
                              ColorsInt.colorPrimary1.withOpacity(0.2),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  ShowToast(String message, context) {
    showToast(message,
        context: context,
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        position: StyledToastPosition.center,
        animDuration: Duration(seconds: 1),
        duration: Duration(seconds: 4),
        curve: Curves.elasticOut,
        reverseCurve: Curves.linear);
  }

  static void displaySnackBar(BuildContext context, String message) {
    message = message.replaceAll(RegExp('"'), '');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool validateEmail(String? value) {
    String pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return true;
    else
      return false;
  }

  bool validateMobileNumber(String? value) {
    if (value!.length <= 9 || value.length >= 11) {
      return true;
    } else {
      return false;
    }
  }

  String TotalTime(String time, String addTime) {
    List<String> time1 = time.split(":");
    print("time array is $time1");
    int Hour = int.parse(time1[0]);
    int Minut = int.parse(time1[1]);
    int Second = int.parse(time1[2]);
    List<String> timeadd = addTime.split(":");
    int HourAdd = int.parse(timeadd[0]);
    int MinutAdd = int.parse(timeadd[1]);
    int SecondAdd = int.parse(timeadd[2]);
    print("time array is $timeadd");

    Second = Second + SecondAdd;
    if (Second > 60) {
      Minut = (Minut + (Second / 60)).toInt();
      Second = Second % 60;
    }
    Minut = Minut + MinutAdd;
    if (Minut > 60) {
      Hour = Hour + (Minut / 60).toInt();
      Minut = Minut % 60;
    }

    Hour = Hour + HourAdd;
    return "$Hour:$Minut:$Second";
  }

  String printDifference2(int milise) {
    //milliseconds
    int different = milise;

    int secondsInMilli = 1000;
    int minutesInMilli = secondsInMilli * 60;
    int hoursInMilli = minutesInMilli * 60;
    int daysInMilli = hoursInMilli * 24;
    int weeksInMilli = daysInMilli * 7;
    int monthInMilli = daysInMilli * 30;
    int yearInMilli = monthInMilli * 12;

    var elapsedYear = (different / yearInMilli);
    different = different % yearInMilli;

    var elapsedMonths = different / monthInMilli;
    different = different % monthInMilli;

    var elapsedWeeks = different / weeksInMilli;
    different = different % weeksInMilli;

    var elapsedDays = different / daysInMilli;
    different = different % daysInMilli;

    var elapsedHours = different / hoursInMilli;
    different = different % hoursInMilli;

    var elapsedMinutes = different / minutesInMilli;
    different = different % minutesInMilli;

    var elapsedSeconds = different / secondsInMilli;

    if (elapsedYear != 0) {
      return "$elapsedYear years $elapsedDays days ";
    } else if (elapsedMonths != 0) {
      return "$elapsedMonths month $elapsedDays days ";
    } else if (elapsedWeeks != 0) {
      return "$elapsedWeeks weeks $elapsedDays days ";
    } else if (elapsedDays == 0 && elapsedHours == 0) {
      return "$elapsedMinutes min $elapsedSeconds sec ";
    } else if (elapsedDays == 0) {
      return "$elapsedHours hours $elapsedMinutes min ";
    } else if (elapsedDays != 0) {
      return "$elapsedDays days $elapsedHours hours ";
    }
    return "$elapsedDays days $elapsedHours hours$elapsedMinutes min $elapsedSeconds sec ";
  }
}
