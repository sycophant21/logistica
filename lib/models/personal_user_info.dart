import 'package:test_123/models/user_id.dart';
import 'package:test_123/models/user_type.dart';

class PersonalUserInfo {
  String name;
  String phoneNumber;
  String connectionCode;
  String deviceInfo;
  UserType userType;
  UserId userId;
  bool initialised;

  PersonalUserInfo(this.name, this.phoneNumber, this.connectionCode,
      this.deviceInfo, this.userType, this.userId, this.initialised);

  static PersonalUserInfo fromJson(json) {
    bool initialised = json['initialized'];
    String name = '';
    String phoneNumber = '';
    String connectionCode = '';
    String deviceInfo = '';
    if(initialised) {
      name = json['name'];
      phoneNumber = json['phoneNumber'];
      connectionCode = json['connectionCode'];
      deviceInfo = json['deviceInfo'];
    }
    UserType userType = UserType.values.firstWhere((element) {
      return element.name == json['userType'];
    });
    UserId userId = UserId.fromJson(json['userId']);
    return PersonalUserInfo(
        name,
        phoneNumber,
        connectionCode,
        deviceInfo,
        userType,
        userId,
        initialised);
  }

  static Map toJson(PersonalUserInfo personalUserInfo) {
    return {
      'name': personalUserInfo.name,
      'phoneNumber': personalUserInfo.phoneNumber,
      'connectionCode': personalUserInfo.connectionCode,
      'deviceInfo': personalUserInfo.deviceInfo,
      'userType': personalUserInfo.userType.name,
      'userId': UserId.toJson(personalUserInfo.userId),
      'initialized': personalUserInfo.initialised
    };
  }

  static PersonalUserInfo empty() {
    return PersonalUserInfo(
        '', '', '', '', UserType.BOTH, UserId.empty(), false);
  }

  static bool isEmpty(PersonalUserInfo personalUserInfo) {
    return personalUserInfo.name == '' &&
        personalUserInfo.phoneNumber == '' &&
        personalUserInfo.connectionCode == '' &&
        personalUserInfo.deviceInfo == '' &&
        personalUserInfo.userType == UserType.BOTH &&
        UserId.isEmpty(personalUserInfo.userId) &&
        !personalUserInfo.initialised;
  }
}
