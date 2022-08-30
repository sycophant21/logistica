import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/models/new_dispatcher_info.dart';

class DispatcherInfoScreen extends StatelessWidget {
  final NewDispatcherInfo newDispatcherInfo;
  final TextEditingController companyNameTextEditingController =
      TextEditingController();
  final TextEditingController companyAddressTextEditingController =
      TextEditingController();
  final TextEditingController truckTypeTextEditingController =
      TextEditingController();
  final TextEditingController fleetSizeTextEditingController =
      TextEditingController();
  final TextEditingController usdotNumberTextEditingController =
      TextEditingController();

  bool checkedValue = false;
  final APIHandler apiHandler = APIHandler.getAPIHandler();

  DispatcherInfoScreen({Key? key, required this.newDispatcherInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoFormSection(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: CupertinoTextFormFieldRow(
            controller: companyNameTextEditingController,
            placeholderStyle:
                TextStyle(color: Colors.black.withOpacity(0.35)),
            placeholder: 'Enter Company Name',
            onSaved: (value) {
              newDispatcherInfo.dispatcher.companyName = value!;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: CupertinoTextFormFieldRow(
            controller: companyAddressTextEditingController,
            placeholderStyle:
                TextStyle(color: Colors.black.withOpacity(0.35)),
            placeholder: 'Enter Company Address',
            maxLines: 4,
            onSaved: (value) {
              newDispatcherInfo.dispatcher.companyAddress = value!;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: CupertinoTextFormFieldRow(
            controller: truckTypeTextEditingController,
            placeholderStyle:
                TextStyle(color: Colors.black.withOpacity(0.35)),
            placeholder: 'Enter Truck Type',
            onSaved: (value) {
              newDispatcherInfo.dispatcher.truckType = value!;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: CupertinoTextFormFieldRow(
            controller: fleetSizeTextEditingController,
            placeholderStyle:
                TextStyle(color: Colors.black.withOpacity(0.35)),
            placeholder: 'Enter Fleet Size',
            keyboardType: TextInputType.number,
            onSaved: (value) {
              newDispatcherInfo.dispatcher.fleetSize = int.tryParse(value!)!;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: CupertinoTextFormFieldRow(
            controller: usdotNumberTextEditingController,
            placeholderStyle:
                TextStyle(color: Colors.black.withOpacity(0.35)),
            placeholder: 'Enter USDOT Number',
            onSaved: (value) {
              newDispatcherInfo.dispatcher.usDOTNumber = value!;
            },
          ),
        ),
      ],
    );
  }
}
