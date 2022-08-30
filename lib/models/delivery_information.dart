import 'package:test_123/models/co_ordinates.dart';

class DeliveryInformation {
   CoOrdinates coOrdinates;
   String contactName;
   String contactNumber;
   String address;

  DeliveryInformation(
      this.coOrdinates, this.contactName, this.contactNumber, this.address);

  static DeliveryInformation fromJson(Map<String, dynamic> json) {
    return DeliveryInformation(
      CoOrdinates.fromJson(json['coOrdinates']),
      json['contactName'],
      json['contactNumber'],
      json['address'],
    );
  }

  static Map toJson(DeliveryInformation deliveryInformation) {
    return {
      'coOrdinates': CoOrdinates.toJson(deliveryInformation.coOrdinates),
      'contactName': deliveryInformation.contactName,
      'contactNumber': deliveryInformation.contactNumber,
      'address': deliveryInformation.address,
    };
  }

  static DeliveryInformation empty() {
    return DeliveryInformation(
      CoOrdinates.empty(),
      '',
      '',
      '',
    );
  }


}