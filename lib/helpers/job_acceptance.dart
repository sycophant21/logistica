import 'package:test_123/models/job_acceptance_status.dart';

class JobAcceptance {
  final String jobId;
  final String userId;
  final JobAcceptanceStatus jobAcceptanceStatus;


  JobAcceptance(this.jobId, this.userId, this.jobAcceptanceStatus);

  static Map toJson(JobAcceptance jobAcceptance) {
    return {
      "jobId": jobAcceptance.jobId,
      "jobAcceptanceStatus": jobAcceptance.jobAcceptanceStatus.name,
      "userId": jobAcceptance.userId
    };
  }
}