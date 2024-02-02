import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/model/TimeSlotListModel.dart';
import 'package:doct_app/model/businesslistmodel.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../model/DoctorListModel.dart';
import '../patientcontact/paitentcontact.dart';
import '../utils/apiURLs.dart';

class BookSlot extends StatefulWidget {
  var businessModel;

  var approxTime;

  var amount;

  var serviceId;

  BookSlot(
      {this.businessModel,
      this.approxTime,
      this.amount,
      this.serviceId,
      Key? key})
      : super(key: key);

  @override
  State<BookSlot> createState() => _BookSlotState();
}

class _BookSlotState extends State<BookSlot> {
  late BusinessListModel businessModel;
  List<DoctorListModel> _doctorList = <DoctorListModel>[];
  List<TimeSloteListModel> _morningList = <TimeSloteListModel>[];
  List<TimeSloteListModel> _afternoonList = <TimeSloteListModel>[];
  List<TimeSloteListModel> _eveningList = <TimeSloteListModel>[];
  DoctorListModel doctorListModel = DoctorListModel();
  DateTime currentDate = DateTime.now();
  String? dateSelected = null;
  String? formatted = null;
  String doctorName = "Choose doctor";
  String doctorId = "0";
  int _currentSlotIndex = 1;

  late String selectedDate = "Appointment Date";
  late TabController? _tabController;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    ApiCallDoctorList();
    businessModel = widget.businessModel;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    formatted = formatter.format(currentDate).toString();
    print("service id is ${widget.serviceId}");
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
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
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
                          "${ApiURLs.IMAGE_URL_BUSINESS}${businessModel.busLogo}",
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
                          businessModel.busTitle.toString(),
                          style: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Service Time :${widget.approxTime}",
                          style: TextStyle(
                              color: ColorsInt.colorBlack,
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                        ),
                        Text(
                          "Amount :Rs ${widget.amount}",
                          style: TextStyle(
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
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: ColorsInt.colorWhite,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(7.0)),
                      border: Border.all(
                          color: ColorsInt.colorTextgray.withOpacity(0.1))),
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    child: InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                      onTap: () {
                        if (_doctorList.isNotEmpty) {
                          showDoctorsListDialog();
                        } else {
                          CommonUtils()
                              .ShowToast("No Doctor Available", context);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.0),
                              child: CachedNetworkImage(
                                width: 50,
                                height: 50,
                                fit: BoxFit.fill,
                                imageUrl:
                                    "${ApiURLs.IMAGE_URL_BUSINESS}${doctorListModel.doctPhoto}",
                                placeholder: (context, url) => Image.asset(
                                  "assets/images/logo.png",
                                  width: 50,
                                  height: 50,
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  "assets/images/ic_error.png",
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctorName,
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    doctorListModel.doctDegree.toString() !=
                                            "null"
                                        ? doctorListModel.doctDegree.toString()
                                        : "",
                                    style: TextStyle(
                                        fontFamily: "Inter",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(
                              flex: 1,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              size: 22,
                              color: ColorsInt.colorPrimary1,
                            )
                          ],
                        ),
                      ),
                    ),
                  )),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  "Appointment Date & Time",
                  style: TextStyle(
                      color: ColorsInt.colorBlack,
                      fontFamily: "Roboto-Bold",
                      fontWeight: FontWeight.w600,
                      fontSize: 18),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ColorsInt.colorTextgray.withOpacity(0.2),
                        blurRadius: 4.0,
                      ),
                    ],
                    color: ColorsInt.colorPrimary1,
                    borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                    border: Border.all(
                        color: ColorsInt.colorTextgray.withOpacity(0.2))),
                child: Material(
                  color: ColorsInt.colorPrimary1,
                  borderRadius: BorderRadius.circular(7.0),
                  child: InkWell(
                    onTap: () {
                      _selectDate(context);
                    },
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
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
                            "  $formatted",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: ColorsInt.colorWhite),
                          ),
                          Spacer(
                            flex: 1,
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
                // color: ColorsInt.colorPrimary1,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 15),
                decoration: BoxDecoration(
                  color: ColorsInt.colorPrimary1,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  border: Border.all(color: ColorsInt.colorDashboardItemBorder),
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentSlotIndex == 1
                            ? ColorsInt.colorWhite
                            : ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        border: Border.all(
                            color: _currentSlotIndex == 1
                                ? ColorsInt.colorDashboardItemBorder
                                : ColorsInt.colorPrimary1),
                      ),
                      child: Material(
                        color: _currentSlotIndex == 1
                            ? ColorsInt.colorWhite
                            : ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            _currentSlotIndex = 1;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("Morning",
                                  style: TextStyle(
                                      color: _currentSlotIndex == 1
                                          ? ColorsInt.colorPrimary1
                                          : ColorsInt.colorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Roboto-Regular")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentSlotIndex == 2
                            ? ColorsInt.colorWhite
                            : ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        border: Border.all(
                            color: _currentSlotIndex == 2
                                ? ColorsInt.colorDashboardItemBorder
                                : ColorsInt.colorPrimary1),
                      ),
                      child: Material(
                        color: _currentSlotIndex == 2
                            ? ColorsInt.colorWhite
                            : ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            _currentSlotIndex = 2;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("Afternoon",
                                  style: TextStyle(
                                      color: _currentSlotIndex == 2
                                          ? ColorsInt.colorPrimary1
                                          : ColorsInt.colorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Roboto-Regular")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: _currentSlotIndex == 3
                            ? ColorsInt.colorWhite
                            : ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.all(Radius.circular(7.0)),
                        border: Border.all(
                            color: _currentSlotIndex == 3
                                ? ColorsInt.colorDashboardItemBorder
                                : ColorsInt.colorPrimary1),
                      ),
                      child: Material(
                        color: _currentSlotIndex == 3
                            ? ColorsInt.colorWhite
                            : ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onTap: () {
                            _currentSlotIndex = 3;
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text("Evening",
                                  style: TextStyle(
                                      color: _currentSlotIndex == 3
                                          ? ColorsInt.colorPrimary1
                                          : ColorsInt.colorWhite,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Roboto-Regular")),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              if (_currentSlotIndex == 1) ...[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: _listMorning(context),
                ),
              ] else if (_currentSlotIndex == 2) ...[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: _listAfternoon(context),
                ),
              ] else if (_currentSlotIndex == 3) ...[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: _listEvening(context),
                ),
              ],
            ],
          )),
    );
  }

  Widget _listMorning(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (1 / .4),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: List.generate(_morningList.length, (index) {
        var list = _morningList[index];
        DateTime tempDate =
            new DateFormat("hh:mm:ss").parse(list.slot.toString());
        var time = DateFormat("h:mm a").format(tempDate);
        return Padding(
          padding: EdgeInsets.all(7.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: list.isBooked!
                      ? ColorsInt.colorRed
                      : ColorsInt.colorPrimary1,
                ),
              ),
              child: Material(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    if (list.isBooked!) {
                      CommonUtils().ShowToast("Slot Already booked", context);
                    } else if (_doctorList.isEmpty) {
                      CommonUtils().ShowToast("No Doctor Available", context);
                    } else {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 500),
                              alignment: Alignment.center,
                              child: PatientContact(
                                approxTime: widget.approxTime,
                                doctorModel: doctorListModel,
                                businessModel: widget.businessModel,
                                serviceId: widget.serviceId,
                                totalAmt: widget.amount,
                                token: list.timeToken.toString(),
                                date: currentDate.toString(),
                                startTime: list.slot.toString(),
                              )));
                    }
                  },
                  child: Center(
                    child: Text(
                      time.toUpperCase(),
                    ),
                  ),
                ),
              )),
        );
      }),
    );
  }

  Widget _listEvening(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (1 / .4),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: List.generate(_eveningList.length, (index) {
        var list = _eveningList[index];
        DateTime tempDate =
            new DateFormat("hh:mm:ss").parse(list.slot.toString());
        var time = DateFormat("h:mm a").format(tempDate);
        return Padding(
          padding: EdgeInsets.all(7.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                border: Border.all(
                  color: list.isBooked!
                      ? ColorsInt.colorRed
                      : ColorsInt.colorPrimary1,
                ),
              ),
              child: Material(
                color: ColorsInt.colorWhite,
                borderRadius: BorderRadius.circular(10.0),
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    if (list.isBooked!) {
                      CommonUtils().ShowToast("Slot Already booked", context);
                    } else if (_doctorList.isEmpty) {
                      CommonUtils().ShowToast("No Doctor Available", context);
                    } else {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.leftToRight,
                              duration: Duration(milliseconds: 500),
                              alignment: Alignment.center,
                              child: PatientContact(
                                approxTime: widget.approxTime,
                                doctorModel: doctorListModel,
                                businessModel: widget.businessModel,
                                serviceId: widget.serviceId,
                                totalAmt: widget.amount,
                                token: list.timeToken.toString(),
                                date: currentDate.toString(),
                                startTime: list.slot.toString(),
                              )));
                    }
                  },
                  child: Center(
                    child: Text(
                      time.toUpperCase(),
                    ),
                  ),
                ),
              )),
        );
      }),
    );
  }

  Widget _listAfternoon(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: (1 / .4),
      shrinkWrap: true,
      physics: ScrollPhysics(),
      children: List.generate(
        _afternoonList.length,
        (index) {
          var list = _afternoonList[index];
          DateTime tempDate =
              new DateFormat("hh:mm:ss").parse(list.slot.toString());
          var time = DateFormat("h:mm a").format(tempDate);
          print("this is date $time");
          return Padding(
            padding: EdgeInsets.all(7.0),
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(
                    color: list.isBooked!
                        ? ColorsInt.colorRed
                        : ColorsInt.colorPrimary1,
                  ),
                ),
                child: Material(
                  color: ColorsInt.colorWhite,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      if (list.isBooked!) {
                        CommonUtils().ShowToast("Slot Already booked", context);
                      } else if (_doctorList.isEmpty) {
                        CommonUtils().ShowToast("No Doctor Available", context);
                      } else {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.leftToRight,
                                duration: Duration(milliseconds: 500),
                                alignment: Alignment.center,
                                child: PatientContact(
                                  approxTime: widget.approxTime,
                                  doctorModel: doctorListModel,
                                  businessModel: widget.businessModel,
                                  serviceId: widget.serviceId,
                                  totalAmt: widget.amount,
                                  token: list.timeToken.toString(),
                                  date: currentDate.toString(),
                                  startTime: list.slot.toString(),
                                )));
                      }
                    },
                    child: Center(
                      child: Text(
                        time.toUpperCase(),
                      ),
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }

  Widget _listDoctors(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _doctorList.length,
      itemBuilder: (context, index) {
        var list = _doctorList[index];
        return InkWell(
          onTap: () {
            if (_doctorList.isNotEmpty) {
              var doctor = "${list.doctName}(${list.doctDegree})";
              doctorName = doctor;
              doctorId = list.doctId.toString();
            }
            setState(() {});
            Navigator.of(context, rootNavigator: true).pop('dialog');
          },
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(27.0),
                  child: CachedNetworkImage(
                    height: 55,
                    width: 55,
                    fit: BoxFit.fill,
                    imageUrl:
                        "${ApiURLs.IMAGE_URL_BUSINESS}${list.doctPhoto.toString()}",
                    placeholder: (context, url) => Image.asset(
                        "assets/images/logo.png",
                        width: 55,
                        height: 55),
                    // progressIndicatorBuilder: (context, url, downloadProgress) =>
                    //     CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/ic_error.png",
                      height: 55,
                      width: 55,
                    ),
                  ),
                ),
                Container(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      list.doctName.toString(),
                      style: TextStyle(
                          color: ColorsInt.colorgray,
                          fontSize: 12,
                          fontFamily: "Roboto-Bold"),
                    ),
                    Text(
                      list.doctDegree.toString(),
                      style: TextStyle(
                          color: ColorsInt.colorgray,
                          fontSize: 12,
                          fontFamily: "Roboto-Bold"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        useRootNavigator: true,
        context: context,
        initialDate: currentDate,
        helpText: "Appointment Date",
        firstDate: DateTime.now(),
        lastDate: DateTime(2099));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        selectedDate = DateFormat("dd-MMM-yyyy").format(pickedDate);
        formatted = selectedDate;
        currentDate = pickedDate;
        dateSelected = pickedDate.toString();
        print("Selected date is ::$pickedDate");
        ApiCallDoctorTimeSlot();
      });
  }

  showDoctorsListDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Container(
                  width: double.maxFinite, child: _listDoctors(context)),
            );
          });
        });
  }

  ApiCallDoctorList() async {
    var body = {"bus_id": widget.businessModel.busId};
    CallApi().PostWithBody(context, ApiURLs.GET_DOCTORS, body).then(
      (response) {
        List responseData = jsonDecode(response!);
        _doctorList.addAll(
            responseData.map((val) => DoctorListModel.fromJson(val)).toList());
        if (_doctorList.isNotEmpty) {
          var doctor = _doctorList[0];
          doctorName = doctor.doctName.toString();
          doctorId = doctor.doctId!;
          doctorListModel = _doctorList[0];
        }
        print("doctor data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        ApiCallDoctorTimeSlot();
      },
    );
  }

  ApiCallDoctorTimeSlot() async {
    var body = {
      "bus_id": widget.businessModel.busId,
      "doct_id": doctorId,
      "date": currentDate.toString()
    };
    CallApi().PostWithBody(context, ApiURLs.TIME_SLOT, body).then(
      (response) {
        Navigator.of(context, rootNavigator: true).pop('dialog');

        if (response != null && response.isNotEmpty && response != "[]") {
          Map responseData = jsonDecode(response!);
          var morning = jsonEncode(responseData["morning"]).toString();
          var evening = jsonEncode(responseData["evening"]).toString();
          var afternoon = jsonEncode(responseData["afternoon"]).toString();
          List morningList = jsonDecode(morning);
          List afternoonList = jsonDecode(afternoon);
          List eveningList = jsonDecode(evening);
          _morningList.clear();
          _morningList.addAll(morningList
              .map((val) => TimeSloteListModel.fromJson(val))
              .toList());
          _eveningList.clear();
          _eveningList.addAll(eveningList
              .map((val) => TimeSloteListModel.fromJson(val))
              .toList());
          _afternoonList.clear();
          _afternoonList.addAll(afternoonList
              .map((val) => TimeSloteListModel.fromJson(val))
              .toList());
          print("time data  is $response");
        } else {
          print("time data  is not available");

          CommonUtils().ShowToast("No booking available", context);
        }
        setState(() {});
      },
    );
  }
}
