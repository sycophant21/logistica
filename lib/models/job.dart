import 'dart:convert';

import 'package:test_123/models/dispatcher.dart';
import 'package:test_123/models/driver_job_response.dart';
import 'package:test_123/models/job_id.dart';
import 'package:test_123/models/job_info.dart';
import 'package:test_123/models/job_status.dart';

class Job {
  String? id;
  JobId jobId;
  Dispatcher dispatcher;
  List<DriverJobResponse> driverJobResponses;
  JobInfo jobInfo;
  JobStatus jobStatus;

  Job(this.id, this.jobId, this.dispatcher, this.driverJobResponses, this.jobInfo,
      this.jobStatus);

  static Job fromJson(json) {
    String id = json['id'];
    JobId jobId = JobId.fromJson(json['jobId']);
    Dispatcher dispatcher = Dispatcher.fromJson(json['dispatcher']);
    List<dynamic> dynamicDriverResponses = json['driverJobResponses'];
    List<DriverJobResponse> driverJobResponses = List.empty(growable: true);
    for(dynamic d in dynamicDriverResponses) {
      driverJobResponses.add(DriverJobResponse.fromJson(d));
    }
    JobInfo jobInfo = JobInfo.fromJson(json['jobInfo']);
    JobStatus jobStatus = JobStatus.values.firstWhere((element) {
      return element.name == json['jobStatus'];
    });
    return Job(id, jobId, dispatcher, driverJobResponses, jobInfo, jobStatus);
  }

  static Map toJson(Job job) {
    return {
      'id' : job.id,
      'jobId': JobId.toJson(job.jobId),
      'dispatcher': Dispatcher.toJson(job.dispatcher),
      'driverJobResponses': job.driverJobResponses.map((e) {
        return DriverJobResponse.toJson(e);
      }).toList(),
      'jobInfo': JobInfo.toJson(job.jobInfo),
      'jobStatus': job.jobStatus.name,
    };
  }

  static Job empty() {
    return Job('', JobId.empty(), Dispatcher.empty(), List.empty(growable: true), JobInfo.empty(), JobStatus.ACQUIRING_INFO);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Job && runtimeType == other.runtimeType && jobId == other.jobId;

  @override
  int get hashCode => jobId.hashCode;
}
