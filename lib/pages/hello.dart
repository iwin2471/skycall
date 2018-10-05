import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
            Text(
              "처음 사용하시나요?",
              style: new TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("발주자로 가입"),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Text("수주자로 가입"),
                  onPressed: () {},
                )
              ],
            ),
            FlatButton(
              child: Text("아뇨 이미 계정이있습니다"),
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/auth");
              },
            )
          ],
        ),
      ),
    );
  }
}
