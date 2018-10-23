import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/area.dart';
import '../scoped-models/main.dart';
import '../models/area.dart';

class MybaljuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MybaljuPageState();
}

class _MybaljuPageState extends State<MybaljuPage> {
  MainModel model;
  Map<String, dynamic> list = {
    "orders": [
      {
        "suppliers": [],
        "_id": "5bb5a604a7c56360bee3d82c",
        "title": "발주입니다",
        "location": 1,
        "work_start_date": "2018-09-30T15:00:00.000Z",
        "work_end_date": "2018-10-24T15:00:00.000Z",
        "max_supplier": 0,
        "writer": {
          "_id": "5bb2cc12a7c56360bee3d827",
          "user_type": 0,
          "user_id": "new_iphone",
          "company_number": "239",
          "company_name": "23",
          "__v": 0
        },
        "write_datetime": "2018-10-04T05:32:52.821Z",
        "__v": 0
      },
    ]
  };
  int length = 1;
  int userType;
  double deviceWidth;
  double deviceHeight;
  double targetWidth;

  String token;

  String duration(String start, String end) {
    DateTime t = DateTime.parse(start);
    DateTime t2 = DateTime.parse(end);
    return t.year.toString() +
        "-" +
        t.month.toString() +
        "-" +
        t.day.toString() +
        " ~ " +
        t2.year.toString() +
        "-" +
        t2.month.toString() +
        "-" +
        t2.day.toString();
  }

  Widget listView(BuildContext context, int item) {
    DateTime t = DateTime.parse(list["orders"][item]["write_datetime"]);
    return ListTile(
      title: Text(
        '[${list["orders"][item]["suppliers"].length}/${list["orders"][item]["max_supplier"]}] ${list["orders"][item]["title"]}',
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
                "${areaList[list["orders"][item]["location"]]}, ${t.toUtc()}"),
          )
        ],
      ),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext _context) {
            return AlertDialog(
              title: Text("발주 상세 정보"),
              content: Container(
                width: targetWidth,
                height: deviceHeight / 2,
                alignment: Alignment.centerLeft,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    Text(
                      "작업명",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      list["orders"][item]["title"],
                    ),
                    Text(
                      "작업지역",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      areaList[list["orders"][item]["location"]],
                    ),
                    Text(
                      "작업기간",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${duration(list["orders"][item]["work_start_date"], list["orders"][item]["work_end_date"])}",
                    ),
                    Text(
                      "모집인원",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      list["orders"][item]["suppliers"].length.toString() +
                          "/" +
                          list["orders"][item]["max_supplier"].toString(),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('취소'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text('수주자 목록'),
                  onPressed: () async {
                    final MainModel model = new MainModel();
                    Map<String, dynamic> requestList =
                        await model.requestList();
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("수주자 신청 목록"),
                          content: Container(
                            width: targetWidth,
                            height: deviceHeight / 2,
                            alignment: Alignment.centerLeft,
                            child: ListView(
                              children: <Widget>[],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('취소'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getlist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeight = MediaQuery.of(context).size.height;
    targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      body: ListView.builder(
        itemCount: length,
        itemBuilder: (BuildContext context, int item) =>
            listView(context, item),
      ),
    );
  }

  void getlist() async {
    final MainModel model = new MainModel();
    final Map<String, dynamic> returnedList = await model.getMyList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");

    if (mounted) {
      setState(() {
        list = returnedList;
        length = list["orders"].length;
      });
    }
  }
}

class MyRequestPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyRequestPageSate();
}

class _MyRequestPageSate extends State<MyRequestPage> {
  void getlist() async {
    final MainModel model = new MainModel();
    final Map<String, dynamic> returnedList = await model.getList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getlist();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
