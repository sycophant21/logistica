import 'package:test_123/models/pay_type.dart';

class PaymentInformation {
  PayType payType;
  double payRate;


  PaymentInformation(this.payType, this.payRate);

  static PaymentInformation fromJson(json) {
    PayType payType = PayType.values.firstWhere((element) {
      return element.name == json['payType'];
    });
    double payRate = json['payRate'];
    return PaymentInformation(payType, payRate);
  }

  static PaymentInformation empty() {
    return PaymentInformation(PayType.PER_HOUR, 0.0);
  }

  static toJson(PaymentInformation paymentInformation) {
    return {
      'payType': paymentInformation.payType.name,
      'payRate': paymentInformation.payRate,
    };
  }

}