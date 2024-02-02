import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/model/catrgoeymodel.dart';
import 'package:doct_app/screen/changePassword/changepassword.dart';
import 'package:doct_app/screen/list/doctorList.dart';
import 'package:doct_app/screen/login/login.dart';
import 'package:doct_app/screen/myappointment/myappointment.dart';
import 'package:doct_app/screen/searchKeywords/searchkeyword.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/updateProfile/updateProfile.dart';
import 'package:doct_app/screen/utils/apiURLs.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../api/call_api.dart';
import '../../model/RecommondedList.dart';
import '../../model/businesslistmodel.dart';
import '../ContactUs/ContactUs.dart';
import '../doctorDetails/doctorDetails.dart';
import '../utils/global.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> _categoryList = <CategoryModel>[];
  List<BusinessListModel> _recommondedList = <BusinessListModel>[];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late AppPreferences _preferences;

  bool userLogin = false;
  String userName = "Guest !";
  String userImgUrl = "";
  String userPhone = "";
  String lat = "";
  String lon = "";

  @override
  void initState() {
    super.initState();
    _preferences = AppPreferences();
    userData();
    ApiCall();
    _determinePosition();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else if (permission == LocationPermission.deniedForever) {
        print("'Location permissions are permanently denied");
      } else {
        print("GPS Location service is granted");
      }
    } else {
      print("GPS Location permission granted.");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude.toString();
      lon = position.longitude.toString();
      print("latitude and longitude${lat},${lon}");
      setState(() {});
    }
    return await Geolocator.getCurrentPosition();
  }

  userData() async {
    userLogin = await _preferences.getUserLogin();
    userName = await _preferences.getUserName();
    userPhone = await _preferences.getUserPhone();
    userName ??= "Guest";
    userPhone ??= "";
    userImgUrl = await _preferences.getUserImage();
    final fcmToken = await FirebaseMessaging.instance.getToken();
    print("Firebase Token$fcmToken");
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawerLogin(),
      // : drawer(),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 130,
              width: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/ic_home_top_img.png"),
                ),
              ),
            ),
          ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 25, left: 20, right: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                        child: Image.asset(
                          "assets/images/ic_menu.png",
                          width: 25,
                          height: 25,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          "Have a good day!".tr(),
                          style: TextStyle(
                              color: ColorsInt.colorText, fontSize: 16),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          userName,
                          style: TextStyle(
                              color: ColorsInt.colorTextHomeUser,
                              fontFamily: "Inter",
                              fontSize: 32,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: ColorsInt.colorWhite,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ColorsInt.colorTextgray
                                      .withOpacity(0.1))),
                          child: Material(
                            color: ColorsInt.colorWhite,
                            borderRadius: BorderRadius.circular(10.0),
                            child: InkWell(
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.bottomToTop,
                                      duration: Duration(milliseconds: 500),
                                      alignment: Alignment.center,
                                      child: SearchWords()),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text("Search Filter",
                                            style: TextStyle(
                                                color: ColorsInt.colorgray,
                                                fontFamily: "Inter",
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400))),
                                    Icon(
                                      Icons.search,
                                      color: ColorsInt.colorTextgray,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20, top: 20, bottom: 10),
                child: Text(
                  "Specialist",
                  style: TextStyle(
                      color: ColorsInt.colorTitleText,
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
              _listSpacialist(context),
              Container(
                margin: EdgeInsets.only(top: 5, left: 20),
                child: Text("Recommended",
                    style: TextStyle(
                        color: ColorsInt.colorTitleText,
                        fontFamily: "Inter",
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 190.0,
                child: _listRecommonded(context),
              )
            ],
          ),
        ],
      ),
    );
  }

  drawerLogin() {
    return Drawer(
      backgroundColor: ColorsInt.colorWhite,
      child: Container(
        margin: EdgeInsets.all(15),
        child: ListView(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 20, top: 30),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/logo.png",
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    "   ${APP_NAME}",
                    style: TextStyle(
                        color: ColorsInt.colorTitleText,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Inter"),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20, top: 10),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      width: 70,
                      height: 70,
                      fit: BoxFit.fill,
                      imageUrl: "${ApiURLs.IMAGE_URL_PROFILE}${userImgUrl}",
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
                      margin: EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: ColorsInt.colorBlack,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter"),
                          ),
                          Text(
                            userPhone,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: ColorsInt.colorText,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "Inter"),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "User Manage",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: ColorsInt.colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter"),
              ),
            ),
            userLogin
                ? InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');

                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 500),
                            alignment: Alignment.center,
                            child: UpdateProfile()),
                      );
                    },
                    child: menuItem(
                        "assets/images/ic_menu_profile.png", "Profile"),
                  )
                : Container(),
            userLogin
                ? InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');

                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 500),
                            alignment: Alignment.center,
                            child: ChangePassword()),
                      );
                    },
                    child: menuItem("assets/images/ic_menu_password.png",
                        "Change Password"),
                  )
                : Container(),
            userLogin
                ? InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');

                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            duration: Duration(milliseconds: 500),
                            alignment: Alignment.center,
                            child: MyAppointment()),
                      );
                    },
                    child: menuItem(
                        "assets/images/ic_menu_calender.png", "My Appointment"),
                  )
                : Container(),
            userLogin
                ? InkWell(
                    onTap: () async {
                      await _preferences.clearPreference();
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      userLogin = false;
                      userName = "Guest";
                      userPhone = "";
                      userImgUrl = "";
                      setState(() {});
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Login()),
                      // );
                    },
                    child:
                        menuItem("assets/images/ic_menu_logout.png", "Logout"),
                  )
                : InkWell(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');

                      // await _preferences.clearPreference();
                      // Navigator.of(context, rootNavigator: true).pop('dialog');
                      // userLogin = false;
                      // setState(() {});
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          duration: Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          child: Login(),
                        ),
                      );
                    },
                    child:
                        menuItem("assets/images/ic_menu_logout.png", "Login"),
                  ),
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 10),
              child: Text(
                "Communicate",
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: ColorsInt.colorBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Inter"),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');

                Share.share(
                    'check out This App https://play.google.com/store/apps/details?id=com.example.doct.app.doct_app');
              },
              child: menuItem("assets/images/ic_menu_share.png", "Share App"),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');

                String appPackageName = "com.example.doct.app.doct_app";
                try {
                  launch("market://details?id=" + appPackageName);
                } on PlatformException catch (e) {
                  launch("https://play.google.com/store/apps/details?id=" +
                      appPackageName);
                } finally {
                  launch("https://play.google.com/store/apps/details?id=" +
                      appPackageName);
                }
              },
              child: menuItem("assets/images/ic_menu_rateus.png", "Rating Us"),
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.of(context, rootNavigator: true).pop('dialog');
            //
            //     Navigator.push(
            //       context,
            //       PageTransition(
            //         type: PageTransitionType.leftToRight,
            //         duration: Duration(milliseconds: 500),
            //         alignment: Alignment.center,
            //         child: ContactUs(),
            //       ),
            //     );
            //   },
            //   child:
            //       menuItem("assets/images/ic_menu_contactus.png", "Contact Us"),
            // ),
          ],
        ),
      ),
    );
  }

  Widget menuItem(String icon, String title) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(children: [
        Image.asset(
          icon,
          width: 24,
          height: 24,
        ),
        Container(
          padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
          child: Text(
            title,
            textAlign: TextAlign.start,
            style: TextStyle(
                color: ColorsInt.colorTitleText,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: "Inter"),
          ),
        )
      ]),
    );
  }

  Widget _listRecommonded(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: _recommondedList.length,
      itemBuilder: (context, index) {
        var list = _recommondedList[index];
        var imgurl = "${ApiURLs.IMAGE_URL_BUSINESS}${list.busLogo}";
        print("image url::$imgurl");
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: ColorsInt.colorTextgray.withOpacity(0.1))),
          width: 250,
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
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
                    child: DoctorDetails(
                      businessModel: list,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          CachedNetworkImage(
                            width: MediaQuery.of(context).size.width,
                            height: 120,
                            fit: BoxFit.cover,
                            imageUrl: imgurl,
                            placeholder: (context, url) => Image.asset(
                              "assets/images/logo.png",
                              height: 120,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/images/ic_error.png",
                              height: 120,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: RatingBarIndicator(
                              rating: double.parse(list.avgRating.toString()),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 20),
                        child: Text(
                          list.busTitle.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: ColorsInt.colorText),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Dental Specialist",
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                              color: ColorsInt.colorText),
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _listSpacialist(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(2),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _categoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 1.0, childAspectRatio: 0.80),
        itemBuilder: (BuildContext context, int index) {
          var list = _categoryList[index];
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: ColorsInt.colorWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorsInt.colorTextgray.withOpacity(0.1))),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorsInt.colorWhite,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            duration: Duration(milliseconds: 500),
                            alignment: Alignment.center,
                            child: DoctorList(
                              catId: list.id.toString(),
                              name: list.title.toString(),
                              lat: lat,
                              lon: lon,
                              radius: 10,
                              isSearch: false,
                              isLatLng: false,
                            )),
                      );
                    },
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: CachedNetworkImage(
                        width: 75,
                        height: 75,
                        fit: BoxFit.cover,
                        imageUrl: "${ApiURLs.IMAGE_URL_CATEGORY}${list.image}",
                        placeholder: (context, url) => Image.asset(
                          "assets/images/logo.png",
                          width: 75,
                          height: 75,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/ic_error.png",
                          width: 75,
                          height: 75,
                        ),
                      ),
                    ),
                  ),
                  // ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                child: AutoSizeText(
                  "${list.title}",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12,
                      color: ColorsInt.colorText,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  ApiCall() async {
    CallApi().get(context, ApiURLs.CATEGORY_LIST).then(
      (response) {
        List responseData = jsonDecode(response!);
        _categoryList.addAll(
            responseData.map((val) => CategoryModel.fromJson(val)).toList());
        print("category data is $response");
        ApiCallRecommonded();
        setState(() {});
      },
    );
  }

  ApiCallRecommonded() async {
    CallApi().get(context, ApiURLs.RECOMMONDED).then(
      (response) {
        List responseData = jsonDecode(response!);
        _recommondedList.addAll(responseData
            .map((val) => BusinessListModel.fromJson(val))
            .toList());
        print("recommonded data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );
  }
}
