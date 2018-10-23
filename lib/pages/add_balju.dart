import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../scoped-models/main.dart';

class AddBaljuPage extends StatefulWidget {
  @override
  _AddBaljuPageSate createState() => _AddBaljuPageSate();
}

class _AddBaljuPageSate extends State<AddBaljuPage> {
  final Map<String, dynamic> _formData = {
    "title": null,
    "location": null,
    "work_start_date": null,
    "work_end_date": null,
    "max_supplier": null,
    "writer": null,
    "token": null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("yyy MMM d");
  List<String> _values;
  String _value;

  String label;
  String label2;
  TextEditingController txt = new TextEditingController();
  TextEditingController txt2 = new TextEditingController();
  DateTime _date = new DateTime.now();

  Widget _buildWorkingNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '작업명', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildMaxSupplier() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '작업자수', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        num maxSupplier = int.parse(value);
        _formData['max_supplier'] = maxSupplier;
      },
    );
  }

  Future _selectDate(
      BuildContext context, int number, TextEditingController txt) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2020),
    );
    if (picked != null) {
      setState(() {
        number == 0 ? label = picked.toString() : label2 = picked.toString();
        number == 0
            ? txt.text = label.split(" ")[0]
            : txt2.text = label2.split(" ")[0];
      });
    }
  }

  Widget _buildWorkPlace(BuildContext context) {
    return DropdownButton<String>(
      value: _value,
      items: _values.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: Text("${value}"),
        );
      }).toList(),
      onChanged: (String value) {
        Map<String, num> locationToNum = {
          '서울특별시': 0,
          '경기도': 1,
          '강원도': 2,
          '충청도': 3,
          '경상도': 4,
          '전라도': 5,
          '제주특별자치도': 6
        };
        _formData['location'] = locationToNum[value];
        setState(() {
          _value = value;
        });
      },
    );
  }

  void _submitForm(Function order) async {
    _formKey.currentState.save();
    Map<String, dynamic> successInformation = await order(_formData);

    if (successInformation['success']) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('발주 성공!'),
            content: Text('발주에 성공하였습니다'),
            actions: <Widget>[
              FlatButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _values = ['서울특별시', '경기도', '강원도', '충청도', '경상도', '전라도', '제주특별자치도'];
    _value = _values[0];
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      appBar: AppBar(title: Text('발주하기')),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: targetWidth,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildWorkingNameTextField(),
                    _buildMaxSupplier(),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: Text("활동지역을 선택해주세요:"),
                        ),
                        _buildWorkPlace(context),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: deviceWidth * 80 / 100,
                          child: TextFormField(
                            controller: txt,
                            decoration: InputDecoration(
                                hintText: "작업 시작일",
                                labelText: label,
                                filled: true,
                                fillColor: Colors.white),
                            keyboardType: TextInputType.number,
                            onSaved: (String value) {
                              _formData['work_start_date'] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context, 0, txt);
                          },
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: deviceWidth * 80 / 100,
                          child: TextFormField(
                            controller: txt2,
                            decoration: InputDecoration(
                                hintText: "작업 종료일",
                                labelText: label2,
                                filled: true,
                                fillColor: Colors.white),
                            keyboardType: TextInputType.number,
                            onSaved: (String value) {
                              _formData['work_end_date'] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context, 1, txt2);
                          },
                        )
                      ],
                    ),
                    Text("오른쪽의 달력표시를 눌러 날짜를 입력해주세요."),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ScopedModelDescendant<MainModel>(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return model.isLoading
                            ? CircularProgressIndicator()
                            : RaisedButton(
                                textColor: Colors.white,
                                child: Text('발주하기'),
                                onPressed: () => _submitForm(model.order),
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
