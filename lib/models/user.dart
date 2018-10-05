class TopLevel {
  String token;
  ClientUser user;

  TopLevel({
    this.token,
    this.user,
  });
}

class ClientUser {
  String id;
  int userType;
  String phone;
  String companyNumber;
  String companyName;

  ClientUser({
    this.id,
    this.userType,
    this.phone,
    this.companyNumber,
    this.companyName,
  });
}

class SupplierUser {
  String id;
  int userType;
  String phone;
  String companyNumber;
  DateTime jobStartDate;
  String nickname;
  num reachableHeight;
  num location;

  SupplierUser(
      {this.id,
      this.userType,
      this.phone,
      this.companyNumber,
      this.jobStartDate,
      this.nickname,
      this.reachableHeight,
      this.location});
}
