import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/main.dart';
import 'package:doct_app/model/DoctorListModel.dart';
import 'package:doct_app/model/businesslistmodel.dart';
import 'package:doct_app/screen/appointmentDetails/AppointmentDetails.dart';
import 'package:doct_app/screen/thankyou/thankyou.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../model/MyAppointmentListModel.dart';
import '../home/Home.dart';
import '../payment/paypalWebView.dart';
import '../utils/apiURLs.dart';
import '../utils/app_preferences.dart';

class PatientContact extends StatefulWidget {
  var date;

  var startTime;

  var token;

  var serviceId;

  BusinessListModel businessModel;

  DoctorListModel doctorModel;

  var approxTime;

  var totalAmt;

  PatientContact(
      {this.date,
      this.startTime,
      this.token,
      this.serviceId,
      this.approxTime,
      this.totalAmt,
      required this.businessModel,
      required this.doctorModel,
      Key? key})
      : super(key: key);

  @override
  State<PatientContact> createState() => _PatientContactState();
}

class _PatientContactState extends State<PatientContact> {
  AppPreferences _preferences = AppPreferences();
  TextEditingController userNameTextController = TextEditingController();
  TextEditingController userPhoneTextController = TextEditingController();
  TextEditingController userEmailTextController = TextEditingController();
  BusinessListModel businessModel = BusinessListModel();
  DoctorListModel doctorModel = DoctorListModel();
  MyAppointmentListModel _appointmentModel = MyAppointmentListModel();

  var userId = "0";
  String? _date = null;
  String? _time = null;
  int? totalService = 0;

  /// display payment option
  bool PaymentMethord = true;

  int selectedPayIndex = 0 ;


  @override
  void initState() {
    super.initState();
    UserData();
    doctorModel = widget.doctorModel;
    businessModel = widget.businessModel;
    print("service id is ${widget.serviceId}");
    if (widget.serviceId != "0") {
      List<String> sList = widget.serviceId.split(",");
      totalService = sList.length;
    }
    DateTime parseDate =
        new DateFormat("yyyy-MM-dd HH:mm:ss.SSS").parse(widget.date);
    var outputFormat = DateFormat('dd-MMM-yyyy');
    _date = outputFormat.format(parseDate);
    print(_date);
    DateTime tempDate = new DateFormat("hh:mm:ss").parse(widget.startTime);
    _time = DateFormat("h:mm a").format(tempDate);
    print(_time);
  }

  UserData() async {
    String id = await _preferences.getUserId();
    String email = await _preferences.getUserEmail();
    String name = await _preferences.getUserName();
    String phone = await _preferences.getUserPhone();
    userEmailTextController.text = email.toString();
    userNameTextController.text = name.toString();
    userPhoneTextController.text = phone.toString();
    userId = id;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: ColorsInt.colorBG,
        title: Text(
          "Appointment Time",
          style: TextStyle(
              color: ColorsInt.colorTitleText,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      backgroundColor: ColorsInt.colorBG,
      body: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    width: 70,
                    height: 70,
                    fit: BoxFit.fill,
                    imageUrl:
                        "${ApiURLs.IMAGE_URL_BUSINESS}${doctorModel.doctPhoto}",
                    placeholder: (context, url) => Image.asset(
                      "assets/images/logo.png",
                      width: 70,
                      height: 70,
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/ic_error.png",
                      width: 70,
                      height: 70,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorModel.doctName.toString(),
                        style: const TextStyle(
                            fontFamily: "Inter",
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "Service Time : $_time",
                        style: const TextStyle(
                            color: ColorsInt.colorBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                      Text(
                        businessModel.busTitle.toString(),
                        style: const TextStyle(
                            color: ColorsInt.colorBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Appointment Details",
                style: TextStyle(
                    color: ColorsInt.colorBlack,
                    fontFamily: "Roboto-Bold",
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  color: ColorsInt.colorPrimary1,
                  boxShadow: [
                    BoxShadow(
                      color: ColorsInt.colorTextgray.withOpacity(0.2),
                      blurRadius: 4.0,
                    ),
                  ],
                  borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                  border: Border.all(
                      color: ColorsInt.colorTextgray.withOpacity(0.2))),
              child: Material(
                color: ColorsInt.colorPrimary1,
                borderRadius: BorderRadius.circular(7.0),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/ic_calander.png",
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          "   ${_date.toString()}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: ColorsInt.colorWhite),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(7.0)),
                              border: Border.all(color: ColorsInt.colorWhite)),
                          child: Text(
                            " $_time",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorsInt.colorWhite),
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 22,
                          color: ColorsInt.colorWhite,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "Patient Details",
                style: TextStyle(
                    color: ColorsInt.colorBlack,
                    fontFamily: "Roboto-Bold",
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: ColorsInt.colorWhite,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7.0)),
                        border: Border.all(
                            color: ColorsInt.colorDashboardItemBorder)),
                    child: TextFormField(
                      controller: userNameTextController,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Patient Name'),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: ColorsInt.colorWhite,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7.0)),
                        border: Border.all(
                            color: ColorsInt.colorDashboardItemBorder)),
                    child: TextFormField(
                      controller: userPhoneTextController,
                      // maxLength: 10,
                      // counterText: "",
                      decoration:
                          InputDecoration.collapsed(hintText: 'Contact Number'),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: ColorsInt.colorWhite,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(7.0)),
                        border: Border.all(
                            color: ColorsInt.colorDashboardItemBorder)),
                    child: TextFormField(
                      controller: userEmailTextController,
                      decoration:
                          InputDecoration.collapsed(hintText: 'Email Address'),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                ],
              ),
            ),
            if (PaymentMethord)
              Container(
                margin: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  "Payment Option",
                  style: TextStyle(
                      color: ColorsInt.colorBlack,
                      fontFamily: "Roboto-Bold",
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
            if (PaymentMethord)
              Container(
                child: Row(children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // if (userNameTextController.text.isEmpty) {
                        //   CommonUtils().ShowToast("Name Required", context);
                        // } else if (userEmailTextController.text.isEmpty) {
                        //   CommonUtils().ShowToast("Email Required", context);
                        // } else if (userPhoneTextController.text.isEmpty) {
                        //   CommonUtils()
                        //       .ShowToast("Phone Number Required", context);
                        // } else if (CommonUtils().validateMobileNumber(
                        //     userPhoneTextController.text.trim())) {
                        //   CommonUtils.displaySnackBar(
                        //       context, "Enter Valid Phone Number");
                        // } else if (CommonUtils().validateEmail(
                        //     userEmailTextController.text.trim())) {
                        //   CommonUtils.displaySnackBar(
                        //       context, "Enter Valid Email");
                        // } else {
                        //   ApiCallBookAppointmentTemp();
                        // }


                        selectedPayIndex =0;
                        setState(() {

                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedPayIndex==0?ColorsInt.colorBgPayOnline:ColorsInt.colorWhite,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                              color: ColorsInt.colorBgPayOnline),
                        ),
                        margin: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                        padding: EdgeInsets.all(20),
                        child: Center(
                            child: Text("Pay Online",
                                style: TextStyle(
                                    color:selectedPayIndex==0?ColorsInt.colorWhite:ColorsInt.colorBgPayOnline,
                                    fontFamily: "Roboto-Regular",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // if (userNameTextController.text.isEmpty) {
                        //   CommonUtils().ShowToast("Name Required", context);
                        // } else if (userEmailTextController.text.isEmpty) {
                        //   CommonUtils().ShowToast("Email Required", context);
                        // } else if (userPhoneTextController.text.isEmpty) {
                        //   CommonUtils()
                        //       .ShowToast("Phone Number Required", context);
                        // }
                        // else if (CommonUtils().validateMobileNumber(
                        //     userPhoneTextController.text.trim())) {
                        //   CommonUtils.displaySnackBar(
                        //       context, "Enter Valid Phone Number");
                        // } else if (CommonUtils().validateEmail(
                        //     userEmailTextController.text.trim())) {
                        //   CommonUtils.displaySnackBar(
                        //       context, "Enter Valid Email");
                        // } else {
                        //   ApiCallBookAppointment();
                        // }

                        selectedPayIndex=1;
                        setState(() {

                        });

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selectedPayIndex==1?ColorsInt.colorBgPayOnline:ColorsInt.colorWhite,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: ColorsInt.colorBgPayOnline),
                        ),
                        margin: EdgeInsets.only(left: 10, top: 10, bottom: 10),
                        padding: EdgeInsets.all(20),
                        child: Center(
                            child: Text("Pay At Location",
                                style: TextStyle(
                                    color: selectedPayIndex==1?ColorsInt.colorWhite:ColorsInt.colorBgPayOnline,
                                    fontFamily: "Roboto-Regular",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15))),
                      ),
                    ),
                  ),
                ]),
              ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(color: ColorsInt.colorPrimary1),
              ),
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Services",
                        style: TextStyle(
                            color: ColorsInt.colorText,
                            fontFamily: "Roboto-Regular",
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                      Text(
                        totalService.toString(),
                        style: TextStyle(
                            color: ColorsInt.colorTitleText,
                            fontFamily: "Roboto-Regular",
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    "${widget.totalAmt} Rs",
                    style: TextStyle(
                        color: ColorsInt.colorTitleText,
                        fontFamily: "Roboto-Regular",
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              height: 15,
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
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    if (userNameTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Name Required", context);
                    } else if (userEmailTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Email Required", context);
                    } else if (userPhoneTextController.text.isEmpty) {
                      CommonUtils().ShowToast("Phone Number Required", context);
                    } else if (CommonUtils().validateMobileNumber(
                        userPhoneTextController.text.trim())) {
                      CommonUtils.displaySnackBar(
                          context, "Enter Valid Phone Number");
                    } else if (CommonUtils()
                        .validateEmail(userEmailTextController.text.trim())) {
                      CommonUtils.displaySnackBar(context, "Enter Valid Email");
                    }else if (selectedPayIndex==0){
                      ApiCallBookAppointmentTemp();
                    }else if(selectedPayIndex==1){
                      ApiCallBookAppointment();
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Center(
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: ColorsInt.colorWhite,
                            fontFamily: "Roboto-Regular",
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ApiCallBookAppointment() async {
    var doc = "0";
    if (doctorModel.doctId != null && doctorModel.doctId != "null") {
      doc = doctorModel.doctId.toString();
    }
    var body = {
      "bus_id": businessModel.busId,
      "doct_id": doctorModel.doctId.toString(),
      "user_fullname": userNameTextController.text,
      "user_phone": userPhoneTextController.text,
      "user_email": userEmailTextController.text,
      "start_time": widget.startTime,
      "time_token": widget.token,
      "appointment_date": widget.date,
      "user_id": userId,
      "services": widget.serviceId,
    };
    print("this is appointment param ::$body");
    CallApi().PostWithBody(context, ApiURLs.BOOKAPPOINTMENT_URL, body).then(
      (response) {
        Map<String, dynamic> responseOfData = jsonDecode(response!);
        _appointmentModel = MyAppointmentListModel.fromJson(responseOfData);
        print("the appointment data is ${_appointmentModel.id}");

        var id = responseOfData["id"].toString();
        var time = responseOfData["start_time"].toString();
        var date = responseOfData["appointment_date"].toString();
        var patientName = responseOfData["app_name"].toString();
        var patientPhone = responseOfData["app_phone"].toString();
        var amount = responseOfData["payment_amount"].toString();

        print("Appointment data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');


        // (Route<dynamic> route) => false);

        //
        // Navigator.of(context).pushAndRemoveUntil(
        //     MaterialPageRoute(builder: (context) => Home()),
        //     (Route<dynamic> route) => false);
      },
    );
  }

  ApiCallBookAppointmentTemp() async {
    var doc = "0";
    if (doctorModel.doctId != null && doctorModel.doctId != "null") {
      doc = doctorModel.doctId.toString();
    }
    var body = {
      "bus_id": businessModel.busId,
      "doct_id": doctorModel.doctId.toString(),
      "user_fullname": userNameTextController.text,
      "user_phone": userPhoneTextController.text,
      "user_email": userEmailTextController.text,
      "start_time": widget.startTime,
      "time_token": widget.token,
      "appointment_date": widget.date,
      "user_id": userId,
      "services": widget.serviceId,
    };
    print("this is temp appointment param ::$body");
    CallApi()
        .PostWithBodyAppointment(
            context, ApiURLs.TEMP_BOOKAPPOINTMENT_URL, body)
        .then((response) {
      Map responseData = jsonDecode(response!);

      if (responseData.containsKey(ApiURLs.RESPONSE)) {
        if (responseData[ApiURLs.RESPONSE]) {
          if (responseData.containsKey(ApiURLs.ERROR)) {
            var errorString = responseData[ApiURLs.ERROR].toString();
            CommonUtils.displaySnackBar(context, errorString);
          }
          var dataString = jsonEncode(responseData[ApiURLs.DATA]).toString();
          var url = jsonEncode(responseData["payment_url"]).toString();
          Map<String, dynamic> responseOfData = jsonDecode(dataString!);
          _appointmentModel = MyAppointmentListModel.fromJson(responseOfData);
          print("the appointment id is:: ${_appointmentModel.id}");
          //
          // var id = responseOfData["id"].toString();
          // var time = responseOfData["start_time"].toString();
          // var date = responseOfData["appointment_date"].toString();
          // var patientName = responseOfData["app_name"].toString();
          // var patientPhone = responseOfData["app_phone"].toString();
          // var amount = responseOfData["payment_amount"].toString();
          var paymentUrl = responseData["payment_url"].toString();

          print("Appointment data is $response");
          Navigator.of(context, rootNavigator: true).pop('dialog');

          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.bottomToTop,
              duration: Duration(milliseconds: 500),
              alignment: Alignment.center,
              child: Payment(
                booking_data: _appointmentModel,
                paymentUrl: paymentUrl,
              ),
            ),
          );
        }
      }
    });
  }
}
