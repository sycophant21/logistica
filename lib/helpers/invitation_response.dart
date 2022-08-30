import 'package:test_123/helpers/status.dart';

class InvitationResponse {
  final String email;
  final String message;
  final Status status;

  InvitationResponse(this.email, this.message, this.status);

  static InvitationResponse fromJson(json) {
    return InvitationResponse(json['email'], json['message'],
        Status.values.firstWhere((element) {
      return element.name == json['status'];
    }));
  }
}
