import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

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
}
