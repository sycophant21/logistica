import 'package:test_123/models/driver.dart';
import 'package:test_123/models/driver_job_status.dart';

class DriverJobResponse {
  String? driverResponseId;
  Driver driver;
  DriverJobStatus driverJobStatus;

  DriverJobResponse(this.driverResponseId, this.driver, this.driverJobStatus);

  static DriverJobResponse fromJson(json) {
    String? driverResponseId = json['driverResponseId'];
    Driver driver = Driver.fromJson(json['driver']);
    DriverJobStatus driverJobStatus =
        DriverJobStatus.values.firstWhere((element) {
      return element.name == json['driverJobStatus'];
    });
    return DriverJobResponse(driverResponseId, driver, driverJobStatus);
  }

  static Map toJson(DriverJobResponse driverJobResponse) {
    return {
      'driverResponseId': driverJobResponse.driverResponseId,
      'driver': Driver.toJson(driverJobResponse.driver),
      'driverJobStatus': driverJobResponse.driverJobStatus.name,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverJobResponse &&
          runtimeType == other.runtimeType &&
          driver == other.driver;

  @override
  int get hashCode => driver.hashCode;
}
