class UserId {
  String id;

  UserId(this.id);

  static UserId fromJson(json) {
    String id = json['id'];
    return UserId(id);
  }

  static Map toJson(UserId userId) {
    return {
      'id' : userId.id
    };
  }

  static UserId empty() {
    return UserId('');
  }

  static bool isEmpty(UserId userId) {
    return userId.id.isEmpty;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserId && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}