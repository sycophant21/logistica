import 'package:test_123/models/co_ordinates.dart';
import 'package:test_123/models/delivery_information.dart';

class AddressInformation {
  final DeliveryInformation pickupInfo;
  final DeliveryInformation dropOffInfo;

  static AddressInformation empty() {
    return AddressInformation(
      DeliveryInformation.empty(),
      DeliveryInformation.empty(),
    );
  }

  AddressInformation(this.pickupInfo, this.dropOffInfo);

  static AddressInformation fromJson(json) {
    return AddressInformation(
        DeliveryInformation.fromJson(json['pickupInfo']),
        DeliveryInformation.fromJson(json['dropOffInfo']));
  }

  static Map toJson(AddressInformation addressInformation) {
    return {
      'pickupInfo': DeliveryInformation.toJson(addressInformation.pickupInfo),
      'dropOffInfo': DeliveryInformation.toJson(addressInformation.dropOffInfo)
    };
  }
}

