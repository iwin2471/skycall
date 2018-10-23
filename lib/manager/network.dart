class RequestUrls {
  final String signin = "/api/users/sign-in";
  final String signUp = "/api/users/sign-up";
  final String order = "/api/orders";
  final String users = "/api/users/suppliers";
  final String request = "/api/requests";
  final String requestAccpt = "/api/requests/accept";
  final String requestReject = "/api/requests/reject";
  final String requestsMy = "/api/orders/my";
  final String ordersRequests = "/api/orders/requests";

  String get mainurl {
    return "http://iwin247.kr:3000";
  }
}
