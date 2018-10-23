import 'package:flutter/material.dart';

import '../scoped-models/main.dart';
import '../models/area.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Balju {
  int _selectedItem = 0;
  String _value;
  String _introduce;
  List<String> _order = [];

  String get balju => _value;
  set balju(String value) => value = _value;

  String get getIntroduce => _introduce;
  set setIntroduce(String introduce) => _introduce = introduce;

  List<String> get getOrder => _order;
  set setOrder(String order) => _order.add(order);

  int get getSelectedItem => _selectedItem;
  set setSelectedItem(int selectedItem) => _selectedItem = selectedItem;
}

final mybalju = new Balju();

class SujuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SujuPageState();
}

class _SujuPageState extends State<SujuPage> {
  MainModel model;

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
  int userType;
  int selectedItem;
  double deviceWidth;
  double deviceHeight;
  double targetWidth;
  List<String> _values = ["아직 발주한적이없습니다"];
  String _value = "아직 발주한적이없습니다";
  String token;

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token");
    userType = prefs.getInt("userType");

    if (mounted) {
      setState(() {
        list = returnedList;
        length = list["suppliers"].length;
      });
    }
  }

  Widget listView(int item, BuildContext context) {
    String exprienceString =
        exprience(list["suppliers"][item]["job_start_date"]);
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
                "${areaList[list["suppliers"][item]["location"]]}, 작업가능높이:${list["suppliers"][item]["reachable_height"]}m, 경력: " +
                    exprienceString),
          )
        ],
      ),
      onTap: () {
        if (userType == 0) {
          showDialog(
            context: context,
            builder: (BuildContext _context) {
              return AlertDialog(
                title: Text("섭외 요청"),
                content: Container(
                  width: targetWidth,
                  height: deviceHeight / 2,
                  alignment: Alignment.centerLeft,
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Text(
                        "수주자명",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        list["suppliers"][item]["nickname"],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "활동지역",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        areaList[list["suppliers"][item]["location"]],
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "경력",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        exprienceString,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        "작업가능높이",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        list["suppliers"][item]["reachable_height"].toString() +
                            "M",
                        style: TextStyle(fontSize: 20.0),
                      ),
                      BuildMyListWidget(),
                      TextField(
                        decoration: InputDecoration(
                            hintText: "한 줄 자기 소개",
                            filled: true,
                            fillColor: Colors.white),
                        onChanged: (String value) {
                          mybalju.setIntroduce = value;
                        },
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
                    onPressed: () async {
                      final MainModel model = new MainModel();
                      String _supplier = list["suppliers"][item]["_id"];
                      List<String> _order = mybalju.getOrder;
                      String order = _order[mybalju._selectedItem];
                      Map<String, dynamic> result = await model.requestBalju(
                          token, _supplier, order, mybalju.getIntroduce);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Text("${result["message"]}"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    if (result["message"] == "요청이 완료되었습니다")
                                      Navigator.pop(_context);

                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
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
    getUserList();
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
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int item) =>
            listView(item, context),
      ),
    );
  }
}

class BuildMyListWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BildMyListState();
}

class BildMyListState extends State<BuildMyListWidget> {
  int userType;
  String _value;
  List<String> _values = ["adsf"];

  void getUserList() async {
    final MainModel model = new MainModel();
    final Map<String, dynamic> myList = await model.getMyList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userType = prefs.getInt("userType");

    if (myList.length > 0 && userType == 0) {
      setState(() {
        _values = [];
        for (int i = 0; i < myList["orders"].length; i++) {
          _values.add(myList['orders'][i]['title']);
          mybalju.setOrder = myList['orders'][i]['_id'];
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserList();
  }

  @override
  build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text("발주 선택"),
      value: _value,
      items: _values.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: Text("${value}"),
        );
      }).toList(),
      onChanged: (String value) {
        mybalju.balju = value;
        mybalju.setSelectedItem = _values.indexOf(value);
        setState(() {
          _value = value;
        });
      },
    );
  }
}
