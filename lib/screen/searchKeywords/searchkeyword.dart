import 'dart:convert';

import 'package:doct_app/screen/chooseLocality/chooseLocality.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../../model/LocalityListModel.dart';
import '../list/doctorList.dart';
import '../utils/apiURLs.dart';

class SearchWords extends StatefulWidget {
  const SearchWords({Key? key}) : super(key: key);

  @override
  State<SearchWords> createState() => _SearchWordsState();
}

class _SearchWordsState extends State<SearchWords> {
  TextEditingController searchTextController = TextEditingController();

  String lat = "";
  String lon = "";
  List<LocalityListModel> _localityList = <LocalityListModel>[];
  String? LocalityId = null;
  String LocalityName = "Select Locality";

  @override
  void initState() {
    super.initState();
    ApiCallLocalityList();
  }

  int valueHolder = 10;
  bool isSwitched = false;
  String? locality = null;
  String? localityId = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: ColorsInt.colorBG,
        title: Text("Search List",
            style: TextStyle(
                color: ColorsInt.colorTitleText,
                fontWeight: FontWeight.w600,
                fontSize: 16)),
      ),
      backgroundColor: ColorsInt.colorBG,
      body: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: ColorsInt.colorWhite,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  border: Border.all(color: ColorsInt.colorDashboardItemBorder),
                ),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: searchTextController,
                  decoration:
                      InputDecoration.collapsed(hintText: "Search Keywords"),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                padding: EdgeInsets.all(12),
                width: MediaQuery.of(context).size.width - 40,
                decoration: BoxDecoration(
                  color: ColorsInt.colorWhite,
                  borderRadius: BorderRadius.all(Radius.circular(7.0)),
                  border: Border.all(color: ColorsInt.colorDashboardItemBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 25,
                      color: ColorsInt.colorPrimary1,
                    ),
                    hint: Container(
                      width: MediaQuery.of(context).size.width - 110,
                      child: Text(
                        LocalityName.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    value: LocalityId,
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        LocalityId = newValue!;
                      });
                      print(LocalityId);
                    },
                    items: _localityList.map((LocalityListModel map) {
                      return DropdownMenuItem<String>(
                        value: map.localityId.toString(),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 110,
                          child: Text(
                              "${map.locality.toString()},${map.cityName.toString()},${map.countryName.toString()}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(color: Colors.black)),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => ChooseLocality()),
              //     ).then((value) {
              //       if (value != null) {
              //         LocalityListModel localityModel;
              //         localityModel = value;
              //         localityId = localityModel.localityId;
              //         locality = localityModel.locality;
              //         print(
              //             "model is ${localityModel.locality}:::${localityModel.localityId}");
              //         // locality = value.toString();
              //         setState(() {});
              //       }
              //     });
              //   },
              //   child: Container(
              //     margin: EdgeInsets.only(top: 10, bottom: 10),
              //     padding: EdgeInsets.all(12),
              //     width: MediaQuery.of(context).size.width - 40,
              //     decoration: BoxDecoration(
              //       color: ColorsInt.colorWhite,
              //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
              //       border:
              //           Border.all(color: ColorsInt.colorDashboardItemBorder),
              //     ),
              //     child: Text(
              //       locality != null ? locality.toString() : "Search Locality",
              //       style: TextStyle(color: ColorsInt.colorTextgray),
              //     ),
              //   ),
              // ),
              Text("Coverage Area",
                  style:
                      TextStyle(color: ColorsInt.colorTextgray, fontSize: 12)),
              Row(
                children: [
                  Text(
                    "KM $valueHolder",
                    style: TextStyle(
                        color: ColorsInt.colorTextgray,
                        fontSize: 12,
                        fontFamily: "Roboto-Regular"),
                  ),
                  Expanded(
                    child: Slider(
                      value: valueHolder.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 100,
                      activeColor: ColorsInt.colorPrimary1,
                      inactiveColor: Colors.grey,
                      label: '${valueHolder.round()}',
                      onChanged: (double newValue) {
                        setState(() {
                          valueHolder = newValue.round();
                        });
                      },
                      semanticFormatterCallback: (double newValue) {
                        return '${newValue.round()}';
                      },
                    ),
                  ),
                ],
              ),
              Row(children: [
                Text("Near By"),
                Spacer(
                  flex: 1,
                ),
                Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: (value) {
                        isSwitched = value;
                        if (isSwitched) {
                          _determinePosition();
                        }
                        setState(() {});
                      },
                      value: isSwitched,
                      activeColor: ColorsInt.colorPrimary1,
                      activeTrackColor: ColorsInt.colorPrimary1,
                    )),
              ]),
              Container(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                  color: ColorsInt.colorPrimary1,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Material(
                  color: ColorsInt.colorPrimary1,
                  borderRadius: BorderRadius.circular(10.0),
                  child: InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      gotoNext();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Center(
                        child: Text(
                          "Search",
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
          )),
    );
  }

  gotoNext() {
    String tempLN = "";
    String tempLI = "";

    if (LocalityName != "Select Locality") {
      tempLN = LocalityName.toString();
    }
    if (LocalityId != null) {
      tempLI = LocalityId.toString();
    }
    if (isSwitched) {
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            duration: Duration(milliseconds: 500),
            alignment: Alignment.center,
            child: DoctorList(
              isSearch: true,
              lat: lat,
              lon: lon,
              radius: valueHolder,
              locality: tempLN,
              localityId: tempLI,
              search: searchTextController.text.toString(),
              isLatLng: isSwitched,
            )),
      );
    } else {
      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.leftToRight,
            duration: Duration(milliseconds: 500),
            alignment: Alignment.center,
            child: DoctorList(
              isSearch: true,
              lat: "",
              lon: "",
              radius: "",
              locality: tempLN,
              localityId: tempLI,
              isLatLng: isSwitched,
              search: searchTextController.text.toString(),
            )),
      );
    }
  }

  getLocalityValue(newValue) {
    final index =
        _localityList.indexWhere((element) => element.localityId == newValue);
    if (index != -1) {
      print("this is select index $index");
      lat = _localityList[index].localityLat.toString();
      lon = _localityList[index].localityLon.toString();
    } else {
      print("the index is -1");
    }
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

  ApiCallLocalityList() async {
    CallApi().get(context, ApiURLs.GET_LOCALITY).then(
      (response) {
        List responseData = jsonDecode(response!);
        _localityList.clear();
        _localityList.addAll(responseData
            .map((val) => LocalityListModel.fromJson(val))
            .toList());
        print("Locality data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
      },
    );
  }
}
