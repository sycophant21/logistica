class LoginVariables {
  final String username;
  final String password;
  final String deviceId;

  LoginVariables(this.username, this.password, this.deviceId);

  static Map<String, String> toJson(LoginVariables loginVariables) {
    return {
      'username': loginVariables.username,
      'password': loginVariables.password,
      'deviceId' : loginVariables.deviceId,
    };
  }

  static LoginVariables fromJson(json) {
    return LoginVariables(json['username'], json['password'], json['deviceId']);
  }

  static LoginVariables empty() {
    return LoginVariables('', '', '');
  }

  bool isEmpty() {
    return username.isEmpty && password.isEmpty && deviceId.isEmpty;
  }
}
