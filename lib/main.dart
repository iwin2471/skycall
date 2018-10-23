import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/main.dart';
import './pages/hello.dart';
import './scoped-models/main.dart';

void main() => runApp(SkyCall());

class SkyCall extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<SkyCall> {
  final MainModel _model = MainModel();

  @override
  void initState() {
    _model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.indigo,
          accentColor: Colors.indigoAccent,
          buttonColor: Colors.indigo,
        ),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return model.user == null ? HelloPage() : MainPage();
                },
              ),
          '/main': (BuildContext context) => MainPage(),
          '/auth': (BuildContext context) => AuthPage(),
          '/hello': (BuildContext context) => HelloPage(),
          // '/my': ();
        },
      ),
    );
  }
}
