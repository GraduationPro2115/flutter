import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:doct_app/screen/utils/app_preferences.dart';

// import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../api/call_api.dart';
import '../../main.dart';
import '../../model/ReviewListModel.dart';
import '../../model/businesslistmodel.dart';
import '../home/Home.dart';
import '../register/Register.dart';
import '../utils/apiURLs.dart';

class Review extends StatefulWidget {
  BusinessListModel businessModel;

  Review({required this.businessModel, Key? key}) : super(key: key);

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  AppPreferences _preferences = AppPreferences();
  TextEditingController password = TextEditingController();

  List<ReviewListModel> _reviewList = <ReviewListModel>[];
  String userId = "0";

  @override
  void initState() {
    super.initState();
    ApiCallReviewList();
    userData();
  }

  userData() async {
    userId = await _preferences.getUserId();
  }

  ApiCallReviewList() async {
    var body = {"bus_id": widget.businessModel.busId};
    CallApi().PostWithBody(context, ApiURLs.BUSINESS_REVIEWS, body).then(
      (response) {
        List responseData = jsonDecode(response!);
        _reviewList.clear();
        _reviewList.addAll(
            responseData.map((val) => ReviewListModel.fromJson(val)).toList());
        print("category data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        // if (callNextApi) {
        //   ApiCallPhotosList();
        // }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "Review",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ColorsInt.colorBlack),
        ),
        backgroundColor: ColorsInt.colorBG,
      ),
      body: Column(
        children: [
          Expanded(
            child: _listReview(context),
          ),
          Container(
            margin: EdgeInsets.all(20),
            child: Material(
              color: ColorsInt.colorOrange,
              borderRadius: BorderRadius.circular(10.0),
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                onTap: () {
                  dialogRating(context);
                },
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Center(
                    child: Text(
                      "Add Review",
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
          // InkWell(
          //   onTap: () {
          //     dialogRating(context);
          //   },
          //   child: Container(
          //     margin: EdgeInsets.only(bottom: 10),
          //     padding: EdgeInsets.all(15),
          //     width: MediaQuery.of(context).size.width - 40,
          //     decoration: BoxDecoration(
          //       color: ColorsInt.colorOrange,
          //       borderRadius: BorderRadius.all(Radius.circular(7.0)),
          //       border: Border.all(color: ColorsInt.colorDashboardItemBorder),
          //     ),
          //     child: Center(
          //       child: Text(
          //         "Add Review",
          //         style: TextStyle(
          //             color: ColorsInt.colorWhite,
          //             fontSize: 16,
          //             fontWeight: FontWeight.w500),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _listReview(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _reviewList.length,
        itemBuilder: (context, index) {
          var list = _reviewList[index];
          var date =
              DateFormat('dd-MMM-yyyy hh:mm a', "en").format(list.onDate!);
          print(date);

          return Container(
            color: ColorsInt.colorWhite,
            margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
            padding: EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(
                          height: 55,
                          width: 55,
                          fit: BoxFit.fill,
                          imageUrl:
                              "${ApiURLs.IMAGE_URL_PROFILE}${list.userImage}",
                          // "https://images.unsplash.com/photo-1605918321755-0b5ffd8a796a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
                          placeholder: (context, url) =>
                              Image.asset("assets/images/logo.png"),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/ic_error.png"),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              list.userFullname.toString(),
                              style: TextStyle(
                                  color: ColorsInt.colorBlack,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                            RatingBarIndicator(
                              rating: double.parse(list.ratings.toString()),
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              itemCount: 5,
                              itemSize: 20.0,
                              direction: Axis.horizontal,
                            )
                          ],
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        date,
                        style: TextStyle(
                            color: ColorsInt.colorBlack,
                            fontWeight: FontWeight.w400,
                            fontSize: 10),
                      )
                    ],
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 5, top: 5),
                      child: Text(list.reviews.toString(),
                          style: TextStyle(
                              color: ColorsInt.colorBlack,
                              fontWeight: FontWeight.w400,
                              fontSize: 14)))
                ]),
          );
        });
  }

  dialogRating(BuildContext context) {
    int rating = 3;
    TextEditingController reviewEditController = TextEditingController();
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: ColorsInt.colorPrimary1),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Add Review",
        style: TextStyle(color: ColorsInt.colorPrimary1),
      ),
      onPressed: () {
        ApiCallAddReview(reviewEditController.text, rating);
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Your Rating"),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: RatingBar.builder(
              initialRating: 3,
              minRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (val) {
                // rating = int.parse(val.toString());
                print(val);
                rating = val.toInt();
                print(rating);

                setState(() {});
              },
            ),
          ),
          Text("Your Comment"),
          Container(height: 10),
          TextField(
            controller: reviewEditController,
            decoration: const InputDecoration(
              hintText: "Your Comment here",
              labelStyle: TextStyle(color: Color(0xFF424242)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorsInt.colorPrimary1),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: ColorsInt.colorPrimary1),
              ),
            ),
          ),
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  ApiCallAddReview(String review, int rating) async {
    var body = {
      "bus_id": widget.businessModel.busId,
      "user_id": userId,
      "reviews": review,
      "rating": rating.toString(),
    };
    CallApi().PostWithBody(context, ApiURLs.ADD_BUSINESS_REVIEWS, body).then(
      (response) {
        print("review data is  data is $response");
        Navigator.of(context, rootNavigator: true).pop('dialog');
        setState(() {});
        ApiCallReviewList();
      },
    );
  }
}
