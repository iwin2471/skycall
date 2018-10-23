import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/area.dart';
import '../widget/dialog.dart';
import '../scoped-models/main.dart';

class BaljuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BaljuPageState();
}

class _BaljuPageState extends State<BaljuPage> {
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
        if (userType == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return MyAlertDialog(
                title: Text("섭외 요청"),
                content: Container(
                  height: 100.0,
                  alignment: Alignment.centerLeft,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Text(
                        "사업장명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "list['suppliers'][item]",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "한 줄 자기 소개",
                            filled: true,
                            fillColor: Colors.white),
                        onSaved: (String value) {},
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
                    child: Text('섭외 요청'),
                    onPressed: () {},
                  ),
                ],
              );
            },
          );
        }
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
    return Scaffold(
      body: ListView.builder(
        itemCount: length,
        itemBuilder: (BuildContext context, int item) =>
            listView(context, item),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add/balju");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void getlist() async {
    final MainModel model = new MainModel();
    final Map<String, dynamic> returnedList = await model.getList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getInt("userType");
    if (mounted) {
      setState(() {
        list = returnedList;
        length = list["orders"].length;
      });
    }
  }
}
