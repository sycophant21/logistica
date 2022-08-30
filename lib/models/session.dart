import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/session_id.dart';
import 'package:test_123/models/user.dart';
import 'package:test_123/models/user_id.dart';

class Session {
  SessionId sessionId;
  PersonalUserInfo personalUserInfo;
  String message;

  Session(this.sessionId, this.personalUserInfo, this.message);

  static Session fromJson(json) {
    SessionId sessionId = SessionId.fromJson(json['sessionId']);
    PersonalUserInfo personalUserInfo = PersonalUserInfo.fromJson(json['personalUserInfo']);
    String message = json['message'];
    return Session(sessionId, personalUserInfo, message);
  }

  static Session empty() {
    return Session(SessionId.empty(), PersonalUserInfo.empty(), '');
  }

  static bool isEmpty(Session session) {
    return SessionId.isEmpty(session.sessionId) && PersonalUserInfo.isEmpty(session.personalUserInfo);
  }


}