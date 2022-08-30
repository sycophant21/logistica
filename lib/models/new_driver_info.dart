import 'package:test_123/models/driver.dart';

class NewDriverInfo {
  final Driver driver;
  final String dispatcherCode;
  final String password;

  NewDriverInfo(this.driver, this.dispatcherCode, this.password);

  static Map toJson(NewDriverInfo newDriverInfo) {
    return {
      'driver': Driver.toJson(newDriverInfo.driver),
      'dispatcherCode': newDriverInfo.dispatcherCode,
      'password': newDriverInfo.password,
    };
  }
}