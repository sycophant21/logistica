import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/user_id.dart';
import 'package:test_123/models/vehicle_type.dart';

class Driver {
  final UserId userId;
  final String licenseNumber;
  final VehicleType vehicleType;
  final PersonalUserInfo personalUserInfo;

  Driver(this.userId, this.personalUserInfo, this.licenseNumber,
      this.vehicleType);

  static Map toJson(Driver obj) {
    return {
      'userId': UserId.toJson(obj.userId),
      'personalUserInfo': PersonalUserInfo.toJson(obj.personalUserInfo),
      'licenseNumber': obj.licenseNumber,
      'vehicleType': obj.vehicleType.name,
    };
  }

  static Driver fromJson(json) {
    UserId userId = UserId.fromJson(json['userId']);
    String licenseNumber = json['licenseNumber'];
    VehicleType vehicleType = VehicleType.values.firstWhere((element) {
      return element.name == json['vehicleType'];
    });
    PersonalUserInfo personalUserInfo =
        PersonalUserInfo.fromJson(json['personalUserInfo']);

    return Driver(
        userId, personalUserInfo, licenseNumber, vehicleType);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver &&
          runtimeType == other.runtimeType &&
          userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
