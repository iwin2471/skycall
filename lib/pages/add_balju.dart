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
    "user_type": null, //유저 타입 지정 0발주 1 수주
    "user_id": null, //아이디
    "password": null, //비번
    "phone": null, //전화번호
    "company_number": null, //사업자 번호

// Client
    "company_name": null, //사업장 명

// Supplier
    "nickname": null, //별명
    "job_start_date": null, //일시작한 날짜
    "reachable_height": null, //작업 가능 높이
    "location": 0,
    "acceptTerms": false
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("yyy MMM d");
  final TextEditingController _passwordTextController = TextEditingController();
  List<String> _values;
  String _value;

  String label;
  TextEditingController txt = new TextEditingController();
  DateTime _date = new DateTime.now();

  Future _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: new DateTime(1900),
      lastDate: new DateTime(2020),
    );
    if (picked != null) {
      setState(() {
        label = picked.toString();
        txt.text = label.split(" ")[0];
      });
    }
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '아이디', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      onSaved: (String value) {
        _formData['user_id'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '비밀번호', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 0) {
          return '비밀번호는 빈칸이될수없습니다';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '비밀번호 확인', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return '비밀번호가 일치하지않습니다';
        }
      },
    );
  }

  Widget _buildPhone() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '연락처', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['phone'] = value;
      },
    );
  }

  Widget _buildCompanynum() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '사업자 등록번호', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        num company_number = int.parse(value);
        _formData['company_number'] = company_number;
      },
    );
  }

  Widget _buildNickname() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '별명', filled: true, fillColor: Colors.white),
      onSaved: (String value) {
        _formData['nickname'] = value;
      },
    );
  }

  Widget _buildCompanyName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '사업장 명', filled: true, fillColor: Colors.white),
      onSaved: (String value) {
        _formData['company_name'] = value;
      },
    );
  }

  Widget _buildMaxReachableHeight() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '작업 가능 높이(미터)', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['reachable_height'] = value;
      },
    );
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

  Widget _buildAcceptSwitch() {
    return Row(
      children: <Widget>[
        Text('이용약관 동의'),
        Checkbox(
          value: _formData['acceptTerms'],
          onChanged: (bool value) {
            setState(() {
              _formData['acceptTerms'] = value;
            });
          },
        ),
      ],
    );
  }

  void _submitForm(Function signup, num usertype) async {
    _formData['user_type'] = usertype;

    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) return;

    _formKey.currentState.save();
    Map<String, dynamic> successInformation = await signup(_formData);

    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('회원가입에 실패하였습니다.'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
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
      appBar: AppBar(title: Text('')),
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
                    Row(
                      children: <Widget>[
                        Container(
                          width: deviceWidth * 80 / 100,
                          child: TextFormField(
                            controller: txt,
                            decoration: InputDecoration(
                                hintText: "사업 시작일",
                                labelText: label,
                                filled: true,
                                fillColor: Colors.white),
                            keyboardType: TextInputType.number,
                            onSaved: (String value) {
                              _formData['job_start_date'] = value;
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () {
                            _selectDate(context);
                          },
                        )
                      ],
                    ),
                    Text("오른쪽의 달력표시를 눌러 날짜를 입력해주세요."),
                    Text("생각나지 않는 경우, '일'은 정확하지 않아도 됩니다."),
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 10.0),
                          child: Text("활동지역을 선택해주세요:"),
                        ),
                        _buildWorkPlace(context),
                      ],
                    ),
                    _buildAcceptSwitch(),
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
                                child: Text('회원가입'),
                                onPressed: () => _submitForm(model.signUp, 1),
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
