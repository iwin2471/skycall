import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'reg.dart';
import '../models/auth.dart';

class HelloPage extends StatefulWidget {
  @override
  _HelloPageState createState() => _HelloPageState();
}

class _HelloPageState extends State<HelloPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              "처음 사용하시나요?",
              style: new TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 35.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: AutoSizeText("발주자로 가입"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute<Map>(
                        builder: (BuildContext context) {
                          return RegPage(AuthMode.ClientSignup);
                        },
                      ),
                    );
                  },
                ),
                FlatButton(
                  child: AutoSizeText("수주자로 가입"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute<Map>(
                        builder: (BuildContext context) {
                          return RegPage(AuthMode.SuppliersSignup);
                        },
                      ),
                    );
                  },
                )
              ],
            ),
            FlatButton(
              child: Text(
                "아뇨 이미 계정이있습니다",
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/auth");
              },
            )
          ],
        ),
      ),
    );
  }
}
