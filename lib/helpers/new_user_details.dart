class NewUser {
  String name;
  String email;
  String password;
  String companyName;
  String companyAddress;
  int fleetSize;
  String usDOTNumber;
  String truckType;

  NewUser(this.name, this.email, this.password, this.companyName,
      this.companyAddress, this.fleetSize, this.usDOTNumber, this.truckType);

  static NewUser empty() {
    return NewUser('', '', '', '', '', -1, '', '');
  }

  static toJson(NewUser newUser) {
    return {
      'name': newUser.name,
      'email': newUser.email,
      'password': newUser.password,
      'companyName': newUser.companyName,
      'companyAddress': newUser.companyAddress,
      'fleetSize': newUser.fleetSize,
      'usDOTNumber': newUser.usDOTNumber,
      'truckType': newUser.truckType
    };
  }
}