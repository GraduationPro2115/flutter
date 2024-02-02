import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/model/MyAppointmentListModel.dart';
import 'package:doct_app/screen/appointmentDetails/AppointmentDetails.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../api/call_api.dart';
import '../utils/apiURLs.dart';

class MyAppointment extends StatefulWidget {
  const MyAppointment({Key? key}) : super(key: key);

  @override
  State<MyAppointment> createState() => _MyAppointmentState();
}

class _MyAppointmentState extends State<MyAppointment> {
  List<MyAppointmentListModel> _appointmentList = <MyAppointmentListModel>[];
  AppPreferences _preferences = AppPreferences();

  @override
  void initState() {
    super.initState();
    userData();
    initializeDateFormatting();
  }

  userData() async {
    var userId = await _preferences.getUserId();
    print("user id ${userId}");
    ApiCallAppointment(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          title: AutoSizeText(
            "My Appointments",
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: ColorsInt.colorBlack,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: "Manrope"),
          ),
          backgroundColor: ColorsInt.colorWhite,
        ),
        backgroundColor: ColorsInt.colorWhite,
        body: ListView(
          children: [
            _appointmentList.isNotEmpty
                ? _listAppointment(context)
                : Lottie.asset('assets/json/noData.json')
          ],
        ));
  }

  Widget _listAppointment(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _appointmentList.length,
      itemBuilder: (context, index) {
        var list = _appointmentList[index];
        DateTime date =
            DateFormat("yyyy-MM-dd").parse(list.appointmentDate.toString());
        final DateFormat month = DateFormat('MMM-yyyy');
        print(month.format(date));
        final DateFormat day = DateFormat('dd');
        DateTime tempDate =
            DateFormat("hh:mm:ss").parse(list.startTime.toString());
        var dateFormat = DateFormat("h:mm a"); // you can change the format here
        var time = dateFormat.format(tempDate);
        print("time ${time}");
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorsInt.colorBorderMyAppointment)),
          margin: EdgeInsets.only(left: 10, bottom: 20, right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Material(
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: Duration(milliseconds: 500),
                        alignment: Alignment.center,
                        child: AppointmentDetails(appointmentModel: list)),
                  ).then(
                    (value) async {
                      if (value) {
                        _appointmentList.clear();
                        var userId = await _preferences.getUserId();
                        print("user id ${userId}");
                        ApiCallAppointment(userId);
                      }
                    },
                  );
                },
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      padding: EdgeInsets.all(4),
                      color: ColorsInt.colorPrimary1,
                      child: Column(
                        children: [
                          AutoSizeText(
                            month.format(date).toString(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorsInt.colorWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Manrope"),
                          ),
                          AutoSizeText(
                            day.format(date),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorsInt.colorWhite,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Manrope"),
                          ),
                          AutoSizeText(
                            time.toUpperCase(),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: ColorsInt.colorWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Manrope"),
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 15,
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              fit: BoxFit.fill,
                              imageUrl:
                                  "${ApiURLs.IMAGE_URL_BUSINESS}${list.doctPhoto.toString()}",
                              placeholder: (context, url) =>
                                  Image.asset("assets/images/logo.png"),
                              errorWidget: (context, url, error) =>
                                  Image.asset("assets/images/ic_error.png"),
                            ),
                          ),
                          Container(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AutoSizeText(
                                  list.doctName.toString(),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorsInt.colorBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Roboto"),
                                ),
                                AutoSizeText(
                                  list.busTitle.toString(),
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorsInt.colorBlack,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "Roboto"),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              AutoSizeText(
                                "${list.totalAmount}Rs",
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorBlack,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "Manrope"),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: list.isPaid == "0"
                                      ? ColorsInt.colorBgPayOnline
                                          .withOpacity(0.1)
                                      : ColorsInt.colorTextGreen
                                          .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: AutoSizeText(
                                  list.isPaid == "0" ? "Unpaid" : "Paid",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: list.isPaid == "0"
                                          ? ColorsInt.colorBgPayOnline
                                          : ColorsInt.colorTextGreen,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Manrope"),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 15,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ApiCallAppointment(String userId) async {
    var body = {"user_id": userId};
    CallApi().PostWithBody(context, ApiURLs.MYAPPOINTMENT, body).then(
      (response) {
        List responseData = jsonDecode(response!);
        _appointmentList.addAll(responseData
            .map((val) => MyAppointmentListModel.fromJson(val))
            .toList());
        print("appointment data  $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );
  }
}
