import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manager/network.dart';

class BaljuModel extends Model {
  final RequestUrls requestUrls = new RequestUrls();

  Future<Map<String, dynamic>> getList() async {
    http.Response response;
    notifyListeners();

    response = await http.get(
      requestUrls.mainurl + requestUrls.order,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseData;
        break;
      case 400:
        break;
    }
    return responseData;
  }

  Future<Map<String, dynamic>> sujuList() async {
    http.Response response;
    notifyListeners();

    response = await http.get(
      requestUrls.mainurl + requestUrls.users,
    );
    final Map<String, dynamic> responseData = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        return responseData;
        break;
      case 400:
        break;
    }
    return responseData;
  }

  Future<Map<String, dynamic>> requestBalju(
      String token, String supplier, String order, String introduce) async {
    http.Response response;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String client = prefs.getString("_id");

    Map<String, dynamic> requestData = {
      "token": token,
      "client": client,
      "supplier": supplier,
      "order": order,
      "introduce": introduce,
      "type": 1
    };

    response = await http.post(
      requestUrls.mainurl + requestUrls.request,
      headers: {'Content-type': "application/json"},
      body: json.encode(requestData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        return {"message": "요청이 완료되었습니다"};
        break;
      case 400:
        return responseData;
        break;
    }
    return responseData;
  }

  Future<Map<String, dynamic>> order(Map<String, dynamic> orderData) async {
    http.Response response;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    orderData["token"] = prefs.getString("token");

    response = await http.post(
      requestUrls.mainurl + requestUrls.order,
      headers: {'Content-type': "application/json"},
      body: json.encode(orderData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    switch (response.statusCode) {
      case 200:
        return {"success": true};
        break;
      case 400:
        return responseData;
        break;
    }
    return responseData;
  }
}
