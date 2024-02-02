import 'dart:convert';

import 'package:doct_app/model/LocalityListModel.dart';
import 'package:doct_app/screen/theme/Color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/call_api.dart';
import '../utils/apiURLs.dart';

class ChooseLocality extends StatefulWidget {
  const ChooseLocality({Key? key}) : super(key: key);

  @override
  State<ChooseLocality> createState() => _ChooseLocalityState();
}

class _ChooseLocalityState extends State<ChooseLocality> {
  List<LocalityListModel> _localityList = <LocalityListModel>[];

  @override
  void initState() {
    super.initState();
    ApiCallLocalityList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsInt.colorPrimary1,
        title: Text("Choose Locality"),
      ),
      backgroundColor: ColorsInt.colorBG,
      body: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   padding: EdgeInsets.all(15),
              //   margin: EdgeInsets.only(bottom: 10),
              //   width: MediaQuery.of(context).size.width - 40,
              //   decoration: BoxDecoration(
              //     color: ColorsInt.colorWhite,
              //     borderRadius: BorderRadius.all(Radius.circular(7.0)),
              //     border: Border.all(color: ColorsInt.colorDashboardItemBorder),
              //   ),
              //   child: Text(
              //     "search keywords",
              //     style:
              //         TextStyle(color: ColorsInt.colorTextgray, fontSize: 16),
              //   ),
              // ),
              Expanded(child: _list(context))
            ],
          )),
    );
  }

  Widget _list(BuildContext context) {
    return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        itemCount: _localityList.length,
        itemBuilder: (context, index) {
          var list = _localityList[index];
          return InkWell(
            onTap: () {
              Navigator.pop(context, list);
            },
            child: Container(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: Text(
                  "${list.locality.toString()},${list.cityName.toString()},${list.countryName.toString()}"),
            ),
          );
        });
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
