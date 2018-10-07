import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../models/auth.dart';
import '../scoped-models/main.dart';

class RegPage extends StatefulWidget {
  final AuthMode _authMode;
  RegPage(this._authMode);
  @override
  _RegPageState createState() => _RegPageState(this._authMode);
}

class _RegPageState extends State<RegPage> {
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

    "location": null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dateFormat = DateFormat("yyy MMM d");
  final TextEditingController _passwordTextController = TextEditingController();
  List<String> _values;
  String _value;

  AuthMode _authMode;

  _RegPageState(this._authMode);

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
      obscureText: true,
      onSaved: (String value) {
        _formData['phone'] = value;
      },
    );
  }

  Widget _buildCompanynum() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '사업자 등록번호', filled: true, fillColor: Colors.white),
      onSaved: (num company_number) {
        _formData['company_number'] = company_number;
      },
    );
  }

  Widget _buildNickname() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '별명', filled: true, fillColor: Colors.white),
      obscureText: true,
      onSaved: (String value) {
        _formData['nickname'] = value;
      },
    );
  }

  Widget _buildCompanyName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '사업장 명', filled: true, fillColor: Colors.white),
      obscureText: true,
      onSaved: (String value) {
        _formData['companyname'] = value;
      },
    );
  }

  Widget _buildMaxReachableHeight() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: '작업 가능 높이(미터)', filled: true, fillColor: Colors.white),
      onSaved: (String value) {
        _formData['reachableheight'] = value;
      },
    );
  }

  Widget _buildWorkPlace(BuildContext context) {
    return new DropdownButton<String>(
      value: _value,
      items: _values.map((String value) {
        return new DropdownMenuItem(
          value: value,
          child: Text("${value}"),
        );
      }).toList(),
      onChanged: (String value) {
        _formData['reachableheight'] = value;
        setState(() {
          _value = value;
        });
      },
    );
  }

  Widget _buildAcceptSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function signup, bool usertype) async {
    _formData['user_type'] = usertype;

    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) return;

    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    successInformation = await signup(_formData);

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
    _value = "활동 지역을 선택해주세요";
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    if (_authMode == AuthMode.SuppliersSignup) {
      return Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
        ),
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
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordConfirmTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildCompanynum(),
                      _buildNickname(),
                      _buildMaxReachableHeight(),
                      Row(
                        children: <Widget>[
                          Container(
                            width: deviceWidth / 2,
                            child: TextFormField(
                              controller: txt,
                              decoration: InputDecoration(
                                  labelText: label,
                                  filled: true,
                                  fillColor: Colors.white),
                              onSaved: (String value) {
                                _formData['reachableheight'] = value;
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
                      _buildWorkPlace(context),
                      _buildAcceptSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        child: Text(
                            '${_authMode == AuthMode.ClientSignup ? '수주회원가입' : '발주회원가입'}으로 바꾸기'),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.SuppliersSignup
                                ? AuthMode.ClientSignup
                                : AuthMode.SuppliersSignup;
                          });
                        },
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
                                  onPressed: () => _submitForm(model.signUp),
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
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
        ),
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
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordConfirmTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildCompanyName(),
                      _buildPhone(),
                      _buildCompanynum(),
                      _buildAcceptSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      FlatButton(
                        child: Text(
                            '${_authMode == AuthMode.ClientSignup ? '수주회원가입' : '발주회원가입'}으로 바꾸기'),
                        onPressed: () {
                          setState(() {
                            _authMode = _authMode == AuthMode.SuppliersSignup
                                ? AuthMode.ClientSignup
                                : AuthMode.SuppliersSignup;
                          });
                        },
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
                                  onPressed: () => _submitForm(model.signUp),
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
}
