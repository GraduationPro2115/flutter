import 'package:auto_size_text/auto_size_text.dart';
import 'package:doct_app/main.dart';
import 'package:doct_app/screen/myappointment/myappointment.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';

import '../../model/MyAppointmentListModel.dart';
import '../home/Home.dart';

class ThankYou extends StatefulWidget {
  MyAppointmentListModel appointmentModel;

  ThankYou({required this.appointmentModel, Key? key}) : super(key: key);

  @override
  State<ThankYou> createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  MyAppointmentListModel appointmentModel = MyAppointmentListModel();
  var time ="";

  @override
  void initState() {
    super.initState();
    appointmentModel = widget.appointmentModel;
    DateTime tempDate =
    DateFormat("hh:mm:ss").parse(appointmentModel.startTime.toString());
    var dateFormat = DateFormat("h:mm a"); // you can change the format here
    time = dateFormat.format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 120,
              width: 120,
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: const Text(
                "Your appointment is booked Successfully",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: ColorsInt.colorTitleText,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter"),
              ),
            ),
            Container(
              // margin: EdgeInsets.only(left: 15, right: 15, top: 30, bottom: 20),
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
                  Container(
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      "Patient Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: ColorsInt.colorTitleText,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Inter"),
                    ),
                  ),
                  Row(
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
                              appointmentModel.appName.toString(),
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
                              "Mobile",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: ColorsInt.colorText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "Inter"),
                            ),
                            Text(
                              appointmentModel.appPhone.toString(),
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
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    height: 1,
                    color: Colors.black.withOpacity(0.2),
                  ),
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
                        appointmentModel.id.toString(),
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
                                "Doctor",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                appointmentModel.doctName.toString(),
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
                                appointmentModel.busTitle.toString(),
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
                                "Date",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                                appointmentModel.appointmentDate.toString(),
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
                                time,
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
                                "Services",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorsInt.colorText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "Inter"),
                              ),
                              Text(
                               appointmentModel.totalService.toString(),
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
                                "Payment",
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
                                    appointmentModel.totalAmount.toString(),
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
                                      color: appointmentModel.isPaid == "0"
                                          ? ColorsInt.colorBgPayOnline
                                          .withOpacity(0.1)
                                          : ColorsInt.colorTextGreen
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: AutoSizeText(
                                      appointmentModel.isPaid == "0" ? "Unpaid" : "Paid",
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: appointmentModel.isPaid == "0"
                                              ? ColorsInt.colorBgPayOnline
                                              : ColorsInt.colorTextGreen,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Manrope"),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20, bottom: 20),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          child: Home()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  "Back to App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: ColorsInt.colorText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Inter"),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: ColorsInt.colorPrimary1,
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: ColorsInt.colorPrimary1),
              ),
              child: Material(
                color: ColorsInt.colorPrimary1,
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        type: PageTransitionType.bottomToTop,
                        duration: Duration(milliseconds: 500),
                        alignment: Alignment.center,
                        child: MyAppointment(),
                      ),
                    );
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "View Details",
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
            ),
            // InkWell(
            //   onTap: () {
            //     // Navigator.pushReplacement(
            //     //   context,
            //     //   PageTransition(
            //     //     type: PageTransitionType.bottomToTop,
            //     //     duration: Duration(milliseconds: 500),
            //     //     alignment: Alignment.center,
            //     //     child: MyAppointment(),
            //     //   ),
            //     // );
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(bottom: 10),
            //     padding: EdgeInsets.all(15),
            //     width: MediaQuery.of(context).size.width - 40,
            //     decoration: BoxDecoration(
            //       color: ColorsInt.colorPrimary1,
            //       borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //       border: Border.all(color: ColorsInt.colorDashboardItemBorder),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "View Details",
            //         style: TextStyle(
            //             color: ColorsInt.colorWhite,
            //             fontSize: 16,
            //             fontWeight: FontWeight.w500,
            //             fontFamily: "Inter"),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
