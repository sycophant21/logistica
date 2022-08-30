class JobId {
  final String jobId;

  JobId(this.jobId);

  static JobId fromJson(json) {
    return JobId(json['jobId']);
  }

  static JobId empty() {
    return JobId('');
  }

  static Map toJson(JobId jobId) {
    return {'jobId': jobId.jobId};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JobId &&
          runtimeType == other.runtimeType &&
          jobId == other.jobId;

  @override
  int get hashCode => jobId.hashCode;
}