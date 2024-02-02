import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/model/businesslistmodel.dart';
import 'package:doct_app/screen/doctorDetails/doctorDetails.dart';
import 'package:doct_app/screen/searchKeywords/searchkeyword.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/commonUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:page_transition/page_transition.dart';

import '../../api/call_api.dart';
import '../utils/apiURLs.dart';

class DoctorList extends StatefulWidget {
  final catId;
  final lat;
  final lon;
  final locality;
  final search;
  final localityId;
  bool isSearch;
  bool isLatLng;
  final radius;

  var name;

  DoctorList(
      {this.catId,
      required this.isSearch,
      this.search,
      this.lat,
      this.lon,
      this.locality,
      this.localityId,
      this.name,
      this.radius,
      required this.isLatLng,
      Key? key})
      : super(key: key);

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  List<BusinessListModel> _businessList = <BusinessListModel>[];

  @override
  void initState() {
    super.initState();
    ApiCall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorsInt.colorBG,
        appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: ColorsInt.colorWhite,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.name != null
                        ? widget.name.toString()
                        : widget.search.toString(),
                    style: TextStyle(
                        fontFamily: "Manrope",
                        fontWeight: FontWeight.w600,
                        color: ColorsInt.colorBlack),
                  ),
                ),
                InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 500),
                          alignment: Alignment.center,
                          child: SearchWords(),
                        ),
                      );
                    },
                    child: Image.asset(
                      "assets/images/ic_filter_list.png",
                      width: 25,
                      height: 25,
                    )),
              ]),
        ),
        body:  _businessList.length!="0" && _businessList.length!=0  && _businessList.length!=null?
        Container(child: _listRecommonded(context)):
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/logo.png" , height: 150,width: 150,),
                  Text("No Data Found")
                ],
              ),
            )
    
    );
  }

  Widget _listRecommonded(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: _businessList.length,
      itemBuilder: (context, index) {
        var list = _businessList[index];
        var distance =
            double.parse(list.distanceInKm.toString()).toStringAsFixed(3);
        return Container(
          decoration: BoxDecoration(
              color: ColorsInt.colorWhite,
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: ColorsInt.colorTextgray.withOpacity(0.1))),
          margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
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
                      type: PageTransitionType.rightToLeft,
                      duration: Duration(milliseconds: 500),
                      alignment: Alignment.center,
                      child: DoctorDetails(
                        businessModel: list,
                      ),
                    ),
                  );
                },
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: ColorsInt.colorWhite,
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${ApiURLs.IMAGE_URL_BUSINESS}${list.busLogo}",
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
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    end: const Alignment(0.0, -1),
                                    begin: const Alignment(0.0, 0.4),
                                    colors: <Color>[
                                      Colors.black12.withOpacity(0.2),
                                      Colors.black12.withOpacity(0.1)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                left: 10,
                                child: Text("$distance km",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: ColorsInt.colorWhite))),
                            Positioned(
                                bottom: 10,
                                right: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "(${list.totalRating.toString()})",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: ColorsInt.colorWhite),
                                    ),
                                    RatingBarIndicator(
                                      rating: double.parse(
                                          list.avgRating.toString()),
                                      itemBuilder: (context, index) => Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      direction: Axis.horizontal,
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10, left: 15),
                        child: Text(
                          list.busTitle.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: ColorsInt.colorText),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, bottom: 20, top: 5),
                        child: Text(
                          list.busGoogleStreet.toString(),
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

  ApiCall() async {
    Map<String, String>? param;
    if (!widget.isSearch) {
      param = {
        "cat_id": widget.catId.toString(),
        "lat": "22.8110614",
        "lon": "70.86253469999997",
        "rad": "10"
      };
    } else if (widget.isLatLng) {
      param = {
        "search": widget.search.toString(),
        "lat": widget.lat.toString(),
        "lon": widget.lon.toString(),
        "locality": widget.locality.toString(),
        "locality_id": widget.localityId.toString(),
        "rad": widget.radius.toString()
      };
    } else {
      param = {
        "search": widget.search.toString(),
        "locality": widget.locality.toString(),
        "locality_id": widget.localityId.toString(),
      };
    }

    CallApi().PostWithBody(context, ApiURLs.BUSINESS_LIST, param).then(
      (response) {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if (response == "[]") {
          CommonUtils().ShowToast("No Result Found", context);
        } else {
          List responseData = jsonDecode(response!);
          _businessList.addAll(responseData
              .map((val) => BusinessListModel.fromJson(val))
              .toList());
          print("Business data is $response");

          setState(() {});
        }
      },
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Map<MarkerId, Marker> marker = <MarkerId, Marker>{};
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = Set(); //markers for google map
  static const LatLng showLocation = const LatLng(
      20.81694685866047, 71.04242827631785); //location to show in map

  static final CameraPosition _kGooglePlex = CameraPosition(
      target: LatLng(20.81694685866047, 71.04242827631785), zoom: 0);

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title First ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add second marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(20.81694685866047, 71.04242827631785),
        //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Second ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId(showLocation.toString()),
        position: LatLng(20.81694685866047, 71.04242827631785),
        //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Marker Title Third ',
          snippet: 'My Custom Subtitle',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      //add more markers here
    });

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        markers: markers,
        zoomGesturesEnabled: true,
        //enable Zoom in, out on map
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
