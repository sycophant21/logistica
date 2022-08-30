class ScheduleInformation {
  DateTime startTime;
  DateTime finishTime;


  ScheduleInformation(this.startTime, this.finishTime);

  static ScheduleInformation fromJson(json) {
    DateTime startTime = DateTime.parse(json['startTime']);
    DateTime finishTime = DateTime.parse(json['finishTime']);
    return ScheduleInformation(startTime, finishTime);
  }

  static ScheduleInformation empty() {
    DateTime startTime = DateTime.now();
    DateTime finishTime = DateTime.now();
    return ScheduleInformation(startTime, finishTime);
  }

  static toJson(ScheduleInformation scheduleInformation) {
    return {
      'startTime': scheduleInformation.startTime.toIso8601String(),
      'finishTime': scheduleInformation.finishTime.toIso8601String(),
    };
  }

}