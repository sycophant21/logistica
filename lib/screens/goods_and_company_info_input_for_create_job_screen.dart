import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/models/company_requirements.dart';
import 'package:test_123/models/goods_information.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/screens/address_info_input_for_create_job_screen.dart';

class GoodsAndCompanyInfoInputForCreateJobScreen extends StatefulWidget {
  static const String route = '/createNewJob';
  final JobMode jobMode;
  final Job job;

  const GoodsAndCompanyInfoInputForCreateJobScreen({Key? key, required this.job, required this.jobMode})
      : super(key: key);

  @override
  State<GoodsAndCompanyInfoInputForCreateJobScreen> createState() =>
      _GoodsAndCompanyInfoInputForCreateJobScreenState();
}

class _GoodsAndCompanyInfoInputForCreateJobScreenState
    extends State<GoodsAndCompanyInfoInputForCreateJobScreen> {
  late Job job;
  final GlobalKey<FormState> _formKey = GlobalKey();
  double weight = 0.0;
  final TextEditingController commodityInputController =
      TextEditingController();
  String commodity = '';
  final TextEditingController shipperInputController = TextEditingController();
  String shipper = '';

  final TextEditingController deliveredToInputController =
      TextEditingController();
  String deliveredTo = '';

  String commodityDescription = '';
  String companyName = '';

  final TextEditingController driversRequiredInputController =
      TextEditingController();
  String driversRequired = '';
  String subHaulerName = '';

  String id = '${DateTime.now().millisecondsSinceEpoch}';
  late JobMode jobMode;


  @override
  void initState() {
    super.initState();
    job = widget.job;
    jobMode = widget.jobMode;
    if(jobMode == JobMode.EDIT) {
      shipperInputController.text = job.jobInfo.addressInformation.pickupInfo.contactName;
      deliveredToInputController.text = job.jobInfo.addressInformation.dropOffInfo.contactName;
      commodityInputController.text = job.jobInfo.goodsInformation.commodity;
      driversRequiredInputController.text = '${job.jobInfo.companyRequirements.driversRequired}';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Job'),
        centerTitle: true,
        leading: const CupertinoNavigationBarBackButton(),
        actions: [
          CupertinoButton(
              child: const Text('Next'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  job.jobInfo.goodsInformation =
                      GoodsInformation(weight, commodity, commodityDescription);
                  job.jobInfo.companyRequirements = CompanyRequirements(
                      companyName, int.parse(driversRequired), subHaulerName);
                  job.jobInfo.addressInformation.pickupInfo.contactName =
                      shipper;
                  job.jobInfo.addressInformation.dropOffInfo.contactName =
                      deliveredTo;
                  job.id = id;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return AddressInfoInputForCreateJobScreen(
                          job: job,
                          jobMode: jobMode,
                        );
                      },
                    ),
                  );
                }
              })
        ],
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Form(
        key: _formKey,
        child: CupertinoFormSection(
          margin: EdgeInsets.zero,
          header: const Text(
            'Job Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          children: [
            CupertinoTextFormFieldRow(
              textInputAction: TextInputAction.next,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              initialValue: id,
              style: const TextStyle(fontWeight: FontWeight.bold),
              prefix: const Text('Id', style: TextStyle(fontWeight: FontWeight.bold),),
              readOnly: true,
              enabled: false,
            ),
            CupertinoTextFormFieldRow(
              textInputAction: TextInputAction.next,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              controller: shipperInputController,
              prefix: const Text('Exporter', style: TextStyle(fontWeight: FontWeight.bold),),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can not be empty';
                }
                return null;
              },
              onSaved: (value) {
                shipper = value!;
              },
              placeholder: 'Shipment sent by',
            ),
            CupertinoTextFormFieldRow(
              textInputAction: TextInputAction.next,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              controller: deliveredToInputController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can not be empty';
                }
                return null;
              },
              onSaved: (value) {
                deliveredTo = value!;
              },
              placeholder: 'Shipment sent to',
              prefix: const Text('Importer', style: TextStyle(fontWeight: FontWeight.bold),),
            ),
            CupertinoTextFormFieldRow(
              textInputAction: TextInputAction.next,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              controller: commodityInputController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can not be empty';
                }
                return null;
              },
              onSaved: (value) {
                commodity = value!;
              },
              prefix: const Text('Commodity', style: TextStyle(fontWeight: FontWeight.bold),),
              placeholder: 'Commodity to transport',
            ),
            CupertinoTextFormFieldRow(
              textInputAction: TextInputAction.done,
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 16),
              controller: driversRequiredInputController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field can not be empty';
                } else {
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'This field must be a number';
                  }
                }
                return null;
              },
              onSaved: (value) {
                driversRequired = value!;
              },
              readOnly: jobMode == JobMode.EDIT,
              enabled: jobMode == JobMode.CREATE,
              keyboardType: TextInputType.number,
              prefix: const Text('Trucks', style: TextStyle(fontWeight: FontWeight.bold),),
              placeholder: 'Trucks Required',
            ),
          ],
        ),
      ),
    );
  }
}
