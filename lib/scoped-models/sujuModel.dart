import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../manager/network.dart';

class SujuModel extends Model {
  final RequestUrls requestUrls = new RequestUrls();

  Future<Map<String, dynamic>> getMyList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    String url =
        requestUrls.mainurl + requestUrls.requestsMy + "?token=" + token;
    print(token);
    print(url);

    http.Response response;
    notifyListeners();

    response = await http.get(
      url,
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
