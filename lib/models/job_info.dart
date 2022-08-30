import 'package:test_123/models/address_information.dart';
import 'package:test_123/models/co_ordinates.dart';
import 'package:test_123/models/company_requirements.dart';
import 'package:test_123/models/goods_information.dart';
import 'package:test_123/models/payment_information.dart';
import 'package:test_123/models/schedule_information.dart';
import 'package:test_123/models/special_instructions.dart';

class JobInfo {
  CompanyRequirements companyRequirements;
  GoodsInformation goodsInformation;
  PaymentInformation paymentInformation;
  SpecialInstructions specialInstructions;
  ScheduleInformation scheduleInformation;
  AddressInformation addressInformation;


  JobInfo(
      this.companyRequirements,
      this.goodsInformation,
      this.paymentInformation,
      this.specialInstructions,
      this.scheduleInformation,
      this.addressInformation);

  static JobInfo fromJson(json) {
    CompanyRequirements companyRequirements = CompanyRequirements.fromJson(json['companyRequirements']);
    GoodsInformation goodsInformation = GoodsInformation.fromJson(json['goodsInformation']);
    PaymentInformation paymentInformation = PaymentInformation.fromJson(json['paymentInformation']);
    SpecialInstructions specialInstructions = SpecialInstructions.fromJson(json['specialInstructions']);
    ScheduleInformation scheduleInformation = ScheduleInformation.fromJson(json['scheduleInformation']);
    AddressInformation addressInformation = AddressInformation.fromJson(json['addressInformation']);
    return JobInfo(companyRequirements, goodsInformation, paymentInformation, specialInstructions, scheduleInformation, addressInformation);
  }

  static JobInfo empty() {
    CompanyRequirements companyRequirements = CompanyRequirements.empty();
    GoodsInformation goodsInformation = GoodsInformation.empty();
    PaymentInformation paymentInformation = PaymentInformation.empty();
    SpecialInstructions specialInstructions = SpecialInstructions.empty();
    ScheduleInformation scheduleInformation = ScheduleInformation.empty();
    AddressInformation addressInformation = AddressInformation.empty();
    return JobInfo(companyRequirements, goodsInformation, paymentInformation, specialInstructions, scheduleInformation, addressInformation);
  }

  static Map toJson(JobInfo jobInfo) {
    return {
      'companyRequirements': CompanyRequirements.toJson(jobInfo.companyRequirements),
      'goodsInformation': GoodsInformation.toJson(jobInfo.goodsInformation),
      'paymentInformation': PaymentInformation.toJson(jobInfo.paymentInformation),
      'specialInstructions': SpecialInstructions.toJson(jobInfo.specialInstructions),
      'scheduleInformation': ScheduleInformation.toJson(jobInfo.scheduleInformation),
      'addressInformation': AddressInformation.toJson(jobInfo.addressInformation),
    };
  }
}