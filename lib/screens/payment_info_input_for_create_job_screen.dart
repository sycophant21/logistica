import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/pay_type.dart';
import 'package:test_123/models/payment_information.dart';
import 'package:test_123/models/special_instructions.dart';
import 'package:test_123/screens/job_details_verification_screen.dart';

class PaymentInfoInputForCreateJobScreen extends StatefulWidget {
  final JobMode jobMode;
  final Job job;

  const PaymentInfoInputForCreateJobScreen({Key? key, required this.job, required this.jobMode})
      : super(key: key);

  @override
  State<PaymentInfoInputForCreateJobScreen> createState() =>
      _PaymentInfoInputForCreateJobScreenState();
}

class _PaymentInfoInputForCreateJobScreenState
    extends State<PaymentInfoInputForCreateJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  PayType defaultPayType = PayType.PER_HOUR;
  double amountBeingPaid = 0;
  String specialInstructions = '';
  TextEditingController payPerHourTextEditingController =
      TextEditingController();
  TextEditingController payByWeightTextEditingController =
      TextEditingController();
  TextEditingController payPerLoadTextEditingController =
      TextEditingController();
  TextEditingController specialInstructionsTextEditingController =
  TextEditingController();
  final FocusNode _payPerHourFocusNode = FocusNode();
  final FocusNode _payByWeightFocusNode = FocusNode();
  final FocusNode _payPerLoadFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    defaultPayType = widget.job.jobInfo.paymentInformation.payType;
    amountBeingPaid = widget.job.jobInfo.paymentInformation.payRate;
    String payRate = amountBeingPaid.toString().substring(0, amountBeingPaid.toString().indexOf('.') + 2);
    if(defaultPayType == PayType.BY_WEIGHT) {
      payByWeightTextEditingController.text = payRate;
    }
    else if(defaultPayType == PayType.PER_LOAD) {
      payPerLoadTextEditingController.text = payRate;
    }
    else if(defaultPayType == PayType.PER_HOUR) {
      payPerHourTextEditingController.text = payRate;
    }
    specialInstructionsTextEditingController.text = widget.job.jobInfo.specialInstructions.instructions;
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState!.dispose();
    payPerHourTextEditingController.dispose();
    payByWeightTextEditingController.dispose();
    payPerLoadTextEditingController.dispose();
    _payPerHourFocusNode.dispose();
    _payByWeightFocusNode.dispose();
    _payPerLoadFocusNode.dispose();

  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Job'),
        leading: const CupertinoNavigationBarBackButton(),
        centerTitle: true,
        actions: [
          CupertinoButton(
            child: const Text('Next'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.job.jobInfo.paymentInformation =
                    PaymentInformation(defaultPayType, amountBeingPaid);
                widget.job.jobInfo.specialInstructions = SpecialInstructions(
                    specialInstructions, Uint8List.fromList([]));
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return JobDetailsVerificationScreen(job: widget.job, jobMode: widget.jobMode,);
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Form(
        key: _formKey,
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          children: [
            CupertinoFormSection(
              header: const Text(
                'Payment Details',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<PayType>(
                      value: PayType.PER_HOUR,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -2),
                      title: const Text('Pay Per Hour'),
                      groupValue: defaultPayType,
                      onChanged: widget.jobMode == JobMode.EDIT ? null : (value) {
                        setState(() {
                          defaultPayType = value!;
                          if (payByWeightTextEditingController.text.isEmpty &&
                              payPerLoadTextEditingController.text.isNotEmpty) {
                            payPerHourTextEditingController.text =
                                payPerLoadTextEditingController.text;
                          } else if (payByWeightTextEditingController
                                  .text.isNotEmpty &&
                              payPerLoadTextEditingController.text.isEmpty) {
                            payPerHourTextEditingController.text =
                                payByWeightTextEditingController.text;
                          }
                          payByWeightTextEditingController.text = '';
                          payPerLoadTextEditingController.text = '';
                          _payPerHourFocusNode.requestFocus();
                        });
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      focusNode: _payPerHourFocusNode,
                      controller: payPerHourTextEditingController,
                      enabled: widget.jobMode == JobMode.CREATE,
                      readOnly: widget.jobMode == JobMode.EDIT,
                      prefix: const Padding(
                        padding: EdgeInsets.fromLTRB(14, 6, 14, 6),
                        child: Text('\$'),
                      ),
                      padding: EdgeInsets.zero,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      /*inputFormatters: [
                        FilteringTextInputFormatter(RegExp(''), allow: true)
                      ],*/
                      placeholder: 'Amount per hour',
                      validator: (value) {
                        if (defaultPayType == PayType.PER_HOUR) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          return null;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (defaultPayType == PayType.PER_HOUR) {
                          amountBeingPaid = double.tryParse(value!)!;
                        }
                      },
                      onTap: () {
                        setState(() {
                          defaultPayType = PayType.PER_HOUR;
                          if (payByWeightTextEditingController.text.isEmpty &&
                              payPerLoadTextEditingController.text.isNotEmpty) {
                            payPerHourTextEditingController.text =
                                payPerLoadTextEditingController.text;
                          } else if (payByWeightTextEditingController
                                  .text.isNotEmpty &&
                              payPerLoadTextEditingController.text.isEmpty) {
                            payPerHourTextEditingController.text =
                                payByWeightTextEditingController.text;
                          }
                          payByWeightTextEditingController.text = '';
                          payPerLoadTextEditingController.text = '';
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<PayType>(
                      value: PayType.BY_WEIGHT,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -2),
                      title: const Text('Pay By Weight'),
                      groupValue: defaultPayType,
                      onChanged: widget.jobMode == JobMode.EDIT ? null : (value) {
                        setState(() {
                          defaultPayType = value!;
                          if (payPerHourTextEditingController.text.isEmpty &&
                              payPerLoadTextEditingController.text.isNotEmpty) {
                            payByWeightTextEditingController.text =
                                payPerLoadTextEditingController.text;
                          } else if (payPerHourTextEditingController
                                  .text.isNotEmpty &&
                              payPerLoadTextEditingController.text.isEmpty) {
                            payByWeightTextEditingController.text =
                                payPerHourTextEditingController.text;
                          }
                          payPerHourTextEditingController.text = '';
                          payPerLoadTextEditingController.text = '';
                          _payByWeightFocusNode.requestFocus();
                        });
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      focusNode: _payByWeightFocusNode,
                      controller: payByWeightTextEditingController,
                      enabled: widget.jobMode == JobMode.CREATE,
                      readOnly: widget.jobMode == JobMode.EDIT,
                      prefix: const Padding(
                        padding: EdgeInsets.fromLTRB(14, 6, 14, 6),
                        child: Text('\$'),
                      ),
                      padding: EdgeInsets.zero,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      /*inputFormatters: [
                        FilteringTextInputFormatter(RegExp(''), allow: true)
                      ],*/
                      //autofocus: true,
                      placeholder: 'Amount per lbs',
                      validator: (value) {
                        if (defaultPayType == PayType.BY_WEIGHT) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          return null;
                        }
                        return null;
                      },
                      onSaved: (value) {
                        if (defaultPayType == PayType.BY_WEIGHT) {
                          amountBeingPaid = double.tryParse(value!)!;
                        }
                      },
                      onTap: () {
                        setState(() {
                          defaultPayType = PayType.BY_WEIGHT;
                          if (payPerHourTextEditingController.text.isEmpty &&
                              payPerLoadTextEditingController.text.isNotEmpty) {
                            payByWeightTextEditingController.text =
                                payPerLoadTextEditingController.text;
                          } else if (payPerHourTextEditingController
                                  .text.isNotEmpty &&
                              payPerLoadTextEditingController.text.isEmpty) {
                            payByWeightTextEditingController.text =
                                payPerHourTextEditingController.text;
                          }
                          payPerHourTextEditingController.text = '';
                          payPerLoadTextEditingController.text = '';
                        });
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioListTile<PayType>(
                      value: PayType.PER_LOAD,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity:
                          const VisualDensity(horizontal: -4, vertical: -2),
                      title: const Text('Pay Per Load'),
                      groupValue: defaultPayType,
                      onChanged: widget.jobMode == JobMode.EDIT ? null : (value) {
                        setState(() {
                          defaultPayType = value!;
                          if (payPerHourTextEditingController.text.isEmpty &&
                              payByWeightTextEditingController
                                  .text.isNotEmpty) {
                            payPerLoadTextEditingController.text =
                                payByWeightTextEditingController.text;
                          } else if (payPerHourTextEditingController
                                  .text.isNotEmpty &&
                              payByWeightTextEditingController.text.isEmpty) {
                            payPerLoadTextEditingController.text =
                                payPerHourTextEditingController.text;
                          }
                          payPerHourTextEditingController.text = '';
                          payByWeightTextEditingController.text = '';
                          _payPerLoadFocusNode.requestFocus();
                        });
                      },
                    ),
                    CupertinoTextFormFieldRow(
                      focusNode: _payPerLoadFocusNode,
                      controller: payPerLoadTextEditingController,
                      enabled: widget.jobMode == JobMode.CREATE,
                      readOnly: widget.jobMode == JobMode.EDIT,
                      prefix: const Padding(
                        padding: EdgeInsets.fromLTRB(14, 6, 14, 6),
                        child: Text('\$'),
                      ),
                      padding: EdgeInsets.zero,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      /*inputFormatters: [
                        FilteringTextInputFormatter(RegExp(''), allow: true)
                      ],*/
                      placeholder: 'Amount per load',
                      validator: (value) {
                        if (defaultPayType == PayType.PER_LOAD) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the amount';
                          }
                          return null;
                        }
                        return null;
                      },
                      onTap: () {
                        setState(() {
                          defaultPayType = PayType.PER_LOAD;
                          if (payPerHourTextEditingController.text.isEmpty &&
                              payByWeightTextEditingController
                                  .text.isNotEmpty) {
                            payPerLoadTextEditingController.text =
                                payByWeightTextEditingController.text;
                          } else if (payPerHourTextEditingController
                                  .text.isNotEmpty &&
                              payByWeightTextEditingController.text.isEmpty) {
                            payPerLoadTextEditingController.text =
                                payPerHourTextEditingController.text;
                          }
                          payPerHourTextEditingController.text = '';
                          payByWeightTextEditingController.text = '';
                        });
                      },
                      onSaved: (value) {
                        if (defaultPayType == PayType.PER_LOAD) {
                          amountBeingPaid = double.tryParse(value!)!;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Special Instructions',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              children: [
                CupertinoTextFormFieldRow(
                  controller: specialInstructionsTextEditingController,
                  textInputAction: TextInputAction.newline,
                  maxLines: 4,
                  maxLength: 150,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  placeholder: 'Enter any special instructions for drivers',
                  onSaved: (value) {
                    specialInstructions = value!;
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
