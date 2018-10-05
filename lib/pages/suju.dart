import 'package:flutter/material.dart';

import '../scoped-models/main.dart';
import '../models/area.dart';

class SujuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SujuPageState();
}

class _SujuPageState extends State<SujuPage> {
  Map<String, dynamic> list = {
    "suppliers": [
      {
        "_id": "5bb2cc66a7c56360bee3d828",
        "job_start_date": "2000-12-26T15:00:00.000Z",
        "nickname": "김연준",
        "reachable_height": 1000,
        "location": 0
      }
    ]
  };
  int length = 1;

  String exprience(String date) {
    DateTime t = DateTime.parse(date);
    DateTime today = DateTime.now();
    num gap = (today.year * 12 + today.month) - (t.year * 12 + t.month);
    int year = (gap / 12.0).round();
    int month = (gap % 12.0).round();

    return (year > 0 ? "${year}년 " : '') + "${month} 개월";
  }

  void getUserList() async {
    final MainModel model = new MainModel();
    final Map<String, dynamic> returnedList = await model.sujuList();

    if (mounted) {
      setState(() {
        list = returnedList;
        length = list["suppliers"].length;
      });
    }
  }

  Widget listView(int item) {
    return ListTile(
      title: Text(
        '${list["suppliers"][item]["nickname"]}',
        style: new TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            alignment: Alignment.centerLeft,
            child: Text(
                "${areaList[list["suppliers"][item]["location"]]}, 작업가능높이:${list["suppliers"][item]["reachable_height"]}m, 경력: ${exprience(list["suppliers"][item]["job_start_date"])}"),
          )
        ],
      ),
      onTap: () {},
    );
  }

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: length,
        itemBuilder: (BuildContext context, int item) => listView(item),
      ),
    );
  }
}
