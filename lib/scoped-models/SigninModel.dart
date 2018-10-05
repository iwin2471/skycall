import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../models/auth.dart';
import '../manager/network.dart';

class AuthUserModel extends Model {
  ClientUser _authenticatedUser;
  bool _isLoading = false;
}

class SigninModel extends AuthUserModel {
  RequestUrls requestUrls = new RequestUrls();

  ClientUser get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String id, String password,
      [AuthMode mode = AuthMode.Signin]) async {
    http.Response response;

    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> signinData = {
      'user_id': id,
      'password': password,
    };

    if (mode == AuthMode.Signin) {
      response = await http.post(
        requestUrls.mainurl + requestUrls.signin,
        headers: {'Content-type': "application/json"},
        body: json.encode(signinData),
      );
    } else {
      response = await http.post(
        requestUrls.mainurl + requestUrls.signUp,
        body: json.encode(signinData),
      );
    }
    final Map<String, dynamic> responseData = json.decode(response.body);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String message = 'Something went wrong.';
    bool hasError = true;

    switch (response.statusCode) {
      case 200:
        hasError = false;
        message = '로그인에 성공하였습니다';
        _authenticatedUser = ClientUser(
            id: responseData['id'], companyName: responseData['company_name']);
        prefs.setString('token', responseData['token']);
        prefs.setString('id', id);
        _isLoading = false;
        break;
      case 400:
        hasError = true;
        message = responseData['message'];
        _isLoading = false;
        break;
    }
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      final String userId = prefs.getString('id');
      final String phone = prefs.getString('phone');
      _authenticatedUser = ClientUser(id: userId, phone: phone);
      notifyListeners();
    }
  }
}

class UtilityModel extends AuthUserModel {
  bool get isLoading {
    return _isLoading;
  }
}
