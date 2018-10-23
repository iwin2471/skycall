import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'mylistpages.dart';

class MylistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MylistPageState();
  }
}

class _MylistPageState extends State<MylistPage> {
  String id = "";

  void getId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getString('id');
    });
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  @override
  void initState() {
    super.initState();
    getId();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('발주자/수주자 목록'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: '나의 발주 목록',
              ),
              Tab(
                text: '나의 요청 목록',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[MybaljuPage(), MyRequestPage()],
        ),
      ),
    );
  }
}
