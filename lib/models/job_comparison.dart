import 'package:test_123/models/job.dart';

class JobComparison {
  final Job previousJob;
  final Job currentJob;

  JobComparison(this.previousJob, this.currentJob);

  static JobComparison fromJson(json) {
    return JobComparison(
      Job.fromJson(json['previousJob']),
      Job.fromJson(json['currentJob']),
    );
  }
}
