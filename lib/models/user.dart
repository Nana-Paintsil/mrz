import 'package:mrz/models/retail.dart';

class User {
  String token;
  String refreshtoken;
  String expiryTime;
  String nameId;
  String userName;
  String email;
  RetailOutlet retailOutlet;
  User(this.token, this.refreshtoken, this.expiryTime, this.nameId,
      this.userName, this.email, this.retailOutlet);
}
