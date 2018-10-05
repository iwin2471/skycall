class TopLevel {
  List<Order> orders;

  TopLevel({
    this.orders,
  });
}

class Order {
  List<String> suppliers;
  String id;
  String title;
  int location;
  String workStartDate;
  String workEndDate;
  int maxSupplier;
  Writer writer;
  String writeDatetime;
  int v;

  Order({
    this.suppliers,
    this.id,
    this.title,
    this.location,
    this.workStartDate,
    this.workEndDate,
    this.maxSupplier,
    this.writer,
    this.writeDatetime,
    this.v,
  });
}

class Writer {
  String id;
  int userType;
  String userId;
  String companyNumber;
  String companyName;
  int v;

  Writer({
    this.id,
    this.userType,
    this.userId,
    this.companyNumber,
    this.companyName,
    this.v,
  });
}
