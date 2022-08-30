class SessionId {
  final String sessionId;

  SessionId(this.sessionId);

  static SessionId fromJson(json) {
    String sessionId = json['sessionId'];
    return SessionId(sessionId);
  }

  static SessionId empty() {
    return SessionId('');
  }

  static bool isEmpty(SessionId sessionId) {
    return sessionId.sessionId.isEmpty;
  }
}