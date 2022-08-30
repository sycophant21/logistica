import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/user_id.dart';

class User {
  final UserId userId;
  final PersonalUserInfo personalUserInfo;

  User(this.userId, this.personalUserInfo);

  static User fromJson(json) {
    UserId userId = UserId.fromJson(json['userId']);
    PersonalUserInfo personalUserInfo = PersonalUserInfo.fromJson(json['personalUserInfo']);
    return User(userId, personalUserInfo);
  }
}