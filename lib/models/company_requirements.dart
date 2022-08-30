class CompanyRequirements {
  final String companyName;
  final int driversRequired;
  final String subHaulerName;

  CompanyRequirements(
      this.companyName, this.driversRequired, this.subHaulerName);

  static CompanyRequirements fromJson(json) {
    return CompanyRequirements(
      json['companyName'],
      json['driversRequired'],
      json['subHaulerName'],
    );
  }

  static Map toJson(CompanyRequirements companyRequirements) {
    return {
      'companyName': companyRequirements.companyName,
      'driversRequired': companyRequirements.driversRequired,
      'subHaulerName': companyRequirements.subHaulerName,
    };
  }

  static CompanyRequirements empty() {
    return CompanyRequirements('', -1, '');
  }

  static bool isEmpty(CompanyRequirements companyRequirements) {
    return companyRequirements.companyName.isEmpty &&
        companyRequirements.subHaulerName.isEmpty &&
        companyRequirements.driversRequired == -1;
  }
}
