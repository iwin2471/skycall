import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'suju.dart';
import 'balju.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
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
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Text(id),
                    FlatButton(
                      child: Text('로그아웃'),
                      onPressed: () {
                        logout();
                        Navigator.pushReplacementNamed(context, '/hello');
                      },
                    )
                  ],
                ),
                decoration: BoxDecoration(
                  color: Colors.indigo,
                ),
              ),
              ListTile(
                title: Text('나의리스트'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              )
            ],
          ),
        ),
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
          children: <Widget>[BaljuPage(), SujuPage()],
        ),
      ),
    );
  }
}
