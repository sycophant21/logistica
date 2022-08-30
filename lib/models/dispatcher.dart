import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/user_id.dart';

class Dispatcher {
  UserId userId;
  PersonalUserInfo personalUserInfo;
  String companyName;
  String companyAddress;
  int fleetSize;
  String usDOTNumber;
  String truckType;

  Dispatcher(this.userId, this.personalUserInfo, this.companyName,
      this.companyAddress, this.fleetSize, this.usDOTNumber, this.truckType);

  static Map toJson(Dispatcher obj) {
    return {
      'userId': UserId.toJson(obj.userId),
      'personalUserInfo': PersonalUserInfo.toJson(obj.personalUserInfo),
      'companyName': obj.companyName,
      'companyAddress': obj.companyAddress,
      'fleetSize': obj.fleetSize,
      'usdotNumber': obj.usDOTNumber,
      'truckType': obj.truckType,
    };
  }

  static Dispatcher fromJson(json) {
    UserId userId = UserId.fromJson(json['userId']);
    PersonalUserInfo personalUserInfo =
        PersonalUserInfo.fromJson(json['personalUserInfo']);
    String companyName = json['companyName'];
    String companyAddress = json['companyAddress'];
    int fleetSize = json['fleetSize'];
    String usDOTNumber = json['usdotNumber'];
    String truckType = json['truckType'];
    return Dispatcher(userId, personalUserInfo, companyName, companyAddress,
        fleetSize, usDOTNumber, truckType);
  }

  static Dispatcher empty() {
    return Dispatcher(
        UserId.empty(), PersonalUserInfo.empty(), '', '', -1, '', '');
  }

  static bool isEmpty(Dispatcher dispatcher) {
    return UserId.isEmpty(dispatcher.userId) &&
        PersonalUserInfo.isEmpty(dispatcher.personalUserInfo);
  }
}
