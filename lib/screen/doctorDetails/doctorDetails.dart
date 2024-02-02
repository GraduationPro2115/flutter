import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/model/PhotoListModel.dart';
import 'package:doct_app/model/ServiceModel.dart';
import 'package:doct_app/model/businesslistmodel.dart';
import 'package:doct_app/screen/Review/Review.dart';
import 'package:doct_app/screen/bookslot/bookslot.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/apiURLs.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:page_transition/page_transition.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../api/call_api.dart';
import '../../model/DoctorListModel.dart';
import '../../model/ReviewListModel.dart';
import '../login/login.dart';
import 'dart:math' as math;

class DoctorDetails extends StatefulWidget {
  BusinessListModel businessModel;

  DoctorDetails({required this.businessModel, Key? key}) : super(key: key);

  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails>
    with SingleTickerProviderStateMixin {
  bool? checkBoxValue = false;
  List<ServiceModel> _serviceList = <ServiceModel>[];
  List<DoctorListModel> _doctorList = <DoctorListModel>[];
  List<PhotosListModel> _photosList = <PhotosListModel>[];
  late BusinessListModel businessModel;
  var busId = "0";
  String totalTime = "00:00:00";
  String totalAmt = "00";
  String ConsulantFees = "0";
  // String ServiceCharges = "0";
  String ServiceId = "0";
  late TabController _controller;
  int _selectedIndex = 0;
  late AppPreferences _preferences;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _preferences = AppPreferences();
    userData();
    ApiCallService();
    if (widget.businessModel != null) {
      businessModel = widget.businessModel;
      busId = businessModel.busId.toString();
      ConsulantFees = businessModel.busFee.toString();
      var mTime = businessModel.busConTime.toString().split(":");
      totalTime = "${mTime[0]}:hr ${mTime[1]}:min";
      totalAmt = businessModel.busFee.toString();
      _controller = TabController(length: 4, vsync: this);

      _controller.addListener(() {
        setState(() {
          _selectedIndex = _controller.index;
        });
        print("Selected Index: " + _controller.index.toString());
        if (_selectedIndex == 0) {
          ApiCallService();
        } else if (_selectedIndex == 2) {
          ApiCallDoctorList();
        } else if (_selectedIndex == 3) {
          ApiCallPhotosList();
        }
      });
    }
  }

  userData() async {
    isLogin = await _preferences.getUserLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            DefaultTabController(
              length: 4,
              child: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150.0,
                      flexibleSpace: Container(
                        color: ColorsInt.colorImageBg,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ApiURLs.IMAGE_URL_BUSINESS}${businessModel.busLogo}",
                              placeholder: (context, url) => Image.asset(
                                "assets/images/logo.png",
                                height: 150,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/ic_error.png",
                                height: 150,
                              ),
                            ),
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Review(
                                        businessModel: businessModel,
                                      ),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "(${businessModel.totalRating.toString()})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: ColorsInt.colorBlack),
                                    ),
                                    RatingBarIndicator(
                                      rating: double.parse(
                                          businessModel.avgRating.toString()),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        minHeight: 90,
                        maxHeight: 90,
                        child: Container(
                          color: ColorsInt.colorWhite,
                          child: TabBar(
                            isScrollable: true,
                            unselectedLabelColor: ColorsInt.colorgray,
                            labelColor: ColorsInt.colorPrimary1,
                            indicatorColor: ColorsInt.colorPrimary1,
                            tabs: [
                              Tab(
                                text: "SERVICES",
                                icon: Image.asset(
                                  _controller.index == 0
                                      ? "assets/images/ic_tab_service_selected.png"
                                      : "assets/images/ic_tab_service.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Tab(
                                text: "DETAILS",
                                icon: Image.asset(
                                  _controller.index == 1
                                      ? "assets/images/ic_action_clinic_selected.png"
                                      : "assets/images/ic_action_clinic.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Tab(
                                text: "DOCTORS",
                                icon: Image.asset(
                                  _controller.index == 2
                                      ? "assets/images/ic_tab_doctor_selected.png"
                                      : "assets/images/ic_tab_doctor.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                              Tab(
                                text: "PHOTOS",
                                icon: Image.asset(
                                  _controller.index == 3
                                      ? "assets/images/ic_tab_photos_selected.png"
                                      : "assets/images/ic_tab_photos.png",
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ],
                            controller: _controller,
                            indicatorSize: TabBarIndicatorSize.tab,
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  controller: _controller,
                  children: [
                    _serviceList.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: 0),
                            child: _listService(context),
                          )
                        : Lottie.asset('assets/json/noData.json'),
                    _listDetails(context),
                    _doctorList.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: _listDoctors(context),
                          )
                        : Lottie.asset('assets/json/noData.json'),
                    _photosList.isNotEmpty
                        ? Container(
                            margin: EdgeInsets.only(top: 10),
                            child: _listImages(context),
                          )
                        : Lottie.asset('assets/json/noData.json'),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: ColorsInt.colorPrimary1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding:
                                  EdgeInsets.only(top: 10, bottom: 5, left: 15),
                              child: Text("Consultant Fees :",
                                  style: TextStyle(
                                      color: ColorsInt.colorWhite,
                                      fontWeight: FontWeight.w500))),
                          Container(
                              padding: EdgeInsets.only(bottom: 5, left: 15),
                              child: Text("Service Charges :",
                                  style: TextStyle(
                                      color: ColorsInt.colorWhite,
                                      fontWeight: FontWeight.w500))),
                          Container(
                              padding: EdgeInsets.only(bottom: 20, left: 15),
                              child: Text("Approx. Time :",
                                  style: TextStyle(
                                      color: ColorsInt.colorWhite,
                                      fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding:
                                  EdgeInsets.only(top: 10, bottom: 5, left: 15),
                              child: Text("$ConsulantFees Rs",
                                  style: TextStyle(
                                      color: ColorsInt.colorWhite,
                                      fontWeight: FontWeight.w500))),
                          Container(
                              padding: EdgeInsets.only(bottom: 5, left: 15),
                              child: Text("${getServicefees()} Rs",
                                  style: TextStyle(
                                      color: ColorsInt.colorWhite,
                                      fontWeight: FontWeight.w500))),
                          Container(
                              padding: EdgeInsets.only(bottom: 10, left: 15),
                              child: Text("$totalTime",
                                  style: TextStyle(
                                      color: ColorsInt.colorWhite,
                                      fontWeight: FontWeight.w500))),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                            color: ColorsInt.colorDashboardItemBorder),
                      ),
                      child: Material(
                        color: ColorsInt.colorPrimary1,
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            if (isLogin) {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 500),
                                  alignment: Alignment.center,
                                  child: BookSlot(
                                    businessModel: businessModel,
                                    amount: totalAmt,
                                    approxTime: totalTime,
                                    serviceId: ServiceId,
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  duration: Duration(milliseconds: 500),
                                  alignment: Alignment.center,
                                  child: Login(),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Text(
                              "Book",
                              style: TextStyle(
                                  color: ColorsInt.colorWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addTime() async {
    String total = "00:00:00";
    int totalAmount = int.parse(businessModel.busFee.toString());
    String? selectedServiceId = null;

    for (var i = 0; i < _serviceList.length; i++) {
      var list = _serviceList[i];

      if (list.isChecked) {
        total =
            CommonUtils().TotalTime(total, list.businessApproxtime.toString());
        totalAmount = totalAmount + list.discountAmt;
        print("total time in loop  $total");
        if (selectedServiceId != null)
          selectedServiceId = "$selectedServiceId,${list.id}";
        else {
          selectedServiceId = list.id.toString();
        }
      }
      var mTime = total.split(":");

      totalTime = "${mTime[0]}:hr ${mTime[1]}:min";
      totalAmt = totalAmount.toString();
      ServiceId = selectedServiceId.toString();

      setState(() {});
    }
  }

  Widget _listService(BuildContext context) {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _serviceList.length,
        itemBuilder: (context, index) {
          var list = _serviceList[index];
          var detDisc = int.parse(list.serviceDiscount.toString());
          var getAmt = int.parse(list.servicePrice.toString());
          var finalAmt = (getAmt - (detDisc * getAmt / 100));
          list.discountAmt = finalAmt.toInt();
          print("the final amount is $finalAmt");

          return Column(
            children: [
              Container(
                  padding: EdgeInsets.all(20),
                  child: Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${list.serviceTitle.toString()}",
                            style: TextStyle(
                                fontFamily: "Manrope",
                                fontSize: 14,
                                color: ColorsInt.colorText,
                                fontWeight: FontWeight.w500),
                          ),
                          list.serviceDiscount != "0"
                              ? Text(
                                  "${list.serviceDiscount} % Off",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ColorsInt.colorTextSubTitle,
                                      fontWeight: FontWeight.w500),
                                )
                              : Container(),
                        ],
                      ),
                      const Spacer(
                        flex: 1,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${finalAmt.toString()} Rs",
                            style: TextStyle(
                                fontFamily: "Manrope",
                                fontSize: 14,
                                color: ColorsInt.colorPrimary1,
                                fontWeight: FontWeight.w500),
                          ),
                          list.serviceDiscount != "0"
                              ? Text(
                                  "${list.servicePrice.toString()} Rs",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ColorsInt.colorTextSubTitle
                                          .withOpacity(0.6),
                                      fontWeight: FontWeight.w500),
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        decoration: BoxDecoration(
                          color: list.isChecked
                              ? ColorsInt.colorPrimary1
                              : Colors.transparent,
                          borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          border: Border.all(
                              color: list.isChecked
                                  ? ColorsInt.colorPrimary1
                                  : ColorsInt.colorDashboardItemBorder),
                        ),
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: list.isChecked
                              ? ColorsInt.colorPrimary1
                              : Colors.transparent,
                          child: InkWell(
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            onTap: () {
                              setState(() {
                                list.isChecked = !list.isChecked;
                              });

                              addTime();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: list.isChecked
                                  ? const Text("Added",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorsInt.colorWhite,
                                          fontWeight: FontWeight.w500))
                                  : const Text("Add",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: ColorsInt.colorTextgray,
                                          fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 1,
                color: ColorsInt.colorgray.withOpacity(0.3),
              )
            ],
          );
        });
  }

  Widget _listDetails(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: ColorsInt.colorWhite,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              border: Border.all(
                  color: ColorsInt.colorDashboardItemBorder.withOpacity(0.8))),
          child: Material(
            borderRadius: BorderRadius.circular(7),
            child: InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7),
              ),
              onTap: () async {
                try {
                  await MapsLauncher.launchCoordinates(
                      double.parse(businessModel.busLatitude.toString()),
                      double.parse(businessModel.busLongitude.toString()));
                } catch (e) {
                  throw 'Could not launch ::$e';
                }
              },
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        businessModel.busGoogleStreet!,
                        style: TextStyle(
                            color: ColorsInt.colorTitleText,
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Icon(
                      Icons.location_on,
                      size: 25.0,
                      color: ColorsInt.colorPrimary1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Html(
            data: businessModel.busDescription,
          ),
        ),
      ],
    );
  }

  Widget _listDoctors(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: _doctorList.length,
        itemBuilder: (context, index) {
          var list = _doctorList[index];
          return InkWell(
            onTap: () {
              dialogDoctorDetails(context, list);
            },
            child: Container(
              decoration: BoxDecoration(
                  color: ColorsInt.colorWhite,
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  border: Border.all(
                      color:
                          ColorsInt.colorDashboardItemBorder.withOpacity(0.8))),
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(7)),
                        border: Border.all(
                            color: ColorsInt.colorDashboardItemBorder
                                .withOpacity(0.8))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: CachedNetworkImage(
                        height: 45,
                        width: 45,
                        fit: BoxFit.fill,
                        imageUrl:
                            // "https://images.unsplash.com/photo-1617040619263-41c5a9ca7521?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80",
                            "${ApiURLs.IMAGE_URL_BUSINESS}${list.doctPhoto.toString()}",
                        placeholder: (context, url) =>
                            Image.asset("assets/images/logo.png"),
                        // progressIndicatorBuilder: (context, url, downloadProgress) =>
                        //     CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/ic_error.png"),
                      ),
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        // "Ankit Joshi",
                        list.doctName.toString(),
                        style: TextStyle(
                            color: ColorsInt.colorTitleText,
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                      Text(
                        // "BCA",
                        list.doctDegree!,
                        style: TextStyle(
                            color: ColorsInt.colorTitleText,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  dialogDoctorDetails(BuildContext context, DoctorListModel model) {
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CachedNetworkImage(
            height: 140,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fill,
            imageUrl:
                "${ApiURLs.IMAGE_URL_BUSINESS}${model.doctPhoto.toString()}",
            placeholder: (context, url) =>
                Image.asset("assets/images/logo.png"),
            // progressIndicatorBuilder: (context, url, downloadProgress) =>
            //     CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) =>
                Image.asset("assets/images/ic_error.png"),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Name :",
                    style: TextStyle(fontFamily: "Roboto-Bold", fontSize: 12)),
                Text(
                  model.doctName.toString(),
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  height: 15,
                ),
                const Text("Phone :",
                    style: TextStyle(fontFamily: "Roboto-Bold", fontSize: 12)),
                Text(
                  model.doctPhone.toString(),
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  height: 15,
                ),
                const Text("Email :",
                    style: TextStyle(fontFamily: "Roboto-Bold", fontSize: 12)),
                Text(
                  model.doctEmail.toString(),
                  style: TextStyle(fontSize: 12),
                ),
                Container(
                  height: 15,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _listImages(BuildContext context) {
    return GridView.builder(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemCount: _photosList.length,
      itemBuilder: (BuildContext context, int index) {
        var list = _photosList[index];
        String imgUrl = "${ApiURLs.IMAGE_URL_BUSINESS}${list.photoImage}";
        // String imgUrl =
        //     "https://images.unsplash.com/photo-1617472592135-72a181d04b27?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=870&q=80";

        return Container(
          decoration: BoxDecoration(
            color: ColorsInt.colorWhite,
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
            border: Border.all(color: ColorsInt.colorDashboardItemBorder),
          ),
          margin: EdgeInsets.all(7),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                  ),
                  // progressIndicatorBuilder: (context, url, downloadProgress) =>
                  //     CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Image.asset(
                    "assets/images/ic_error.png",
                    fit: BoxFit.cover,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text("Image Name"),
                    ))
                // Padding(padding: EdgeInsets.only(top: 10),child: Text("yes"),)
              ]),
        );
      },
    );
  }

  dialogImageDisplay(BuildContext context, String url) {
    AlertDialog alert = AlertDialog(
        backgroundColor: ColorsInt.colorPrimary1,
        content: Container(
          color: ColorsInt.colorPrimary1,
          height: 400,
          width: MediaQuery.of(context).size.width,
          child: PhotoView(imageProvider: NetworkImage(url)),
        ));

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ApiCallService() async {
    var body = {"bus_id": widget.businessModel.busId};
    CallApi().PostWithBody(context, ApiURLs.BUSINESS_SERVICES, body).then(
      (response) {
        List responseData = jsonDecode(response!);
        _serviceList.clear();
        _serviceList.addAll(
            responseData.map((val) => ServiceModel.fromJson(val)).toList());
        print("category data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        // ApiCallDoctorList();
      },
    );
  }

  ApiCallDoctorList() async {
    var body = {"bus_id": widget.businessModel.busId};
    CallApi().PostWithBody(context, ApiURLs.GET_DOCTORS, body).then(
      (response) {
        List responseData = jsonDecode(response!);
        _doctorList.clear();
        _doctorList.addAll(
            responseData.map((val) => DoctorListModel.fromJson(val)).toList());
        print("category data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );
  }

  ApiCallPhotosList() async {
    var body = {"bus_id": widget.businessModel.busId};
    CallApi().PostWithBody(context, ApiURLs.BUSINESS_PHOTOS, body).then(
      (response) {
        List responseData = jsonDecode(response!);
        _photosList.clear();
        _photosList.addAll(
            responseData.map((val) => PhotosListModel.fromJson(val)).toList());
        print("photos data  is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );
  }

  getServicefees() {

    double x = double.parse(totalAmt);
    double y = double.parse(ConsulantFees);
    double z = x-y;
    return z.toString();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
