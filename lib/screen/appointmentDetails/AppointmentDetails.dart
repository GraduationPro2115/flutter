import 'package:doct_app/main.dart';
import 'package:doct_app/model/MyAppointmentListModel.dart';
import 'package:doct_app/screen/myappointment/myappointment.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../home/Home.dart';
import '../utils/apiURLs.dart';
import '../utils/app_preferences.dart';

class AppointmentDetails extends StatefulWidget {
  MyAppointmentListModel appointmentModel;

  AppointmentDetails({required this.appointmentModel, Key? key})
      : super(key: key);

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  MyAppointmentListModel _appointmentModel = MyAppointmentListModel();
  AppPreferences _preferences = AppPreferences();

  var appointmentDate = "";
  var time = "";

  @override
  void initState() {
    super.initState();
    _appointmentModel = widget.appointmentModel;
    // DateTime date = DateFormat("yyyy-MM-dd hh:mm:ss.ssss")
    //     .parse(_appointmentModel.appointmentDate.toString());
    // final DateFormat aDate = DateFormat('dd-MMM-yyyy');
    // print(aDate.format(date));
    // appointmentDate = aDate.format(date);
    DateTime tempDate =
    DateFormat("hh:mm:ss").parse(_appointmentModel.startTime.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    time = dateFormat.format(tempDate);
    print("time ${time}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        title: Text(
          "Appointment Details",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: ColorsInt.colorBlack,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: "Manrope"),
        ),
        backgroundColor: ColorsInt.colorBG,
      ),
      backgroundColor: ColorsInt.colorBG,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.all(20),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                border: Border.all(color: ColorsInt.colorDashboardItemBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Booking Details",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorsInt.colorTitleText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter"),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        _appointmentModel.id.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: ColorsInt.colorTitleText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Inter"),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Doctor",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                _appointmentModel.doctName.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Clinic",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                _appointmentModel.busTitle.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Date",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                _appointmentModel.appointmentDate.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Time",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                time.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Services",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                _appointmentModel.totalService.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Amount",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${_appointmentModel.totalAmount} Rs",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: ColorsInt.colorTitleText,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "Inter"),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      color: _appointmentModel.isPaid == "0"
                                          ? ColorsInt.colorBgPayOnline
                                          .withOpacity(0.1)
                                          : ColorsInt.colorTextGreen
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      _appointmentModel.isPaid == "0"
                                          ? "Unpaid"
                                          : "Paid",
                                      style: TextStyle(
                                          color: _appointmentModel.isPaid == "0"
                                              ? ColorsInt.colorBgPayOnline
                                              : ColorsInt.colorTextGreen,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Manrope"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    child: const Text(
                      "Patient Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsInt.colorTitleText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Name",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                _appointmentModel.appName.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Phone",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                _appointmentModel.appPhone.toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorTitleText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "Inter"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Email",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: ColorsInt.colorText,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: "Inter"),
                        ),
                        Text(
                          _appointmentModel.appEmail.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              color: ColorsInt.colorTitleText,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 30,
            ),
            _appointmentModel.status == "0"
                ? Container(
                    decoration: BoxDecoration(
                      color: ColorsInt.colorBgCancelAppointment,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: Material(
                      color: ColorsInt.colorBgCancelAppointment,
                      borderRadius: BorderRadius.circular(10.0),
                      child: InkWell(
                        onTap: () {
                          ApiCallCancelAppointment();
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              "Cancel Appointment",
                              style: TextStyle(
                                  color: ColorsInt.colorWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter"),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  ApiCallCancelAppointment() async {
    String? userId = await _preferences.getUserId();
    var body = {"user_id": userId, "app_id": _appointmentModel.id.toString()};
    CallApi().PostWithBody(context, ApiURLs.CANCELAPPOINTMENTS, body).then(
          (response) async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        Navigator.pop(context, true);
      },
    );
  }
}
