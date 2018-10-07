class RequestUrls {
  final String signin = "/api/users/sign-in";
  final String signUp = "/api/users/sign-up";
  final String order = "/api/orders";
  final String users = "/api/users/suppliers";
  final String request = "/api/requests";
  final String requestAccpt = "/api/requests/accept";
  final String requestReject = "/api/requests/reject";
  final String requestsMy = "/api/requests/my";

  String get mainurl {
    return "http://13.124.142.187:3000";
  }
}
