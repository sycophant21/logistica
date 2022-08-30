import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/screens/driver_selection_screen.dart';

class JobDetailsVerificationScreen extends StatelessWidget {
  final Job job;
  final JobMode jobMode;

  const JobDetailsVerificationScreen({Key? key, required this.job, required this.jobMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Job'),
        leading: const CupertinoNavigationBarBackButton(),
        centerTitle: true,
        actions: [
          CupertinoButton(
            child: const Text('Done'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return DriverSelectionScreen(job: job, jobMode: jobMode,);
                  },
                ),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: CupertinoFormSection(

          header: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Verify Job Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                '(id:${job.id})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          children: [
            CupertinoFormSection(
              header: const Text(
                'Requirements',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                CupertinoFormRow(
                  child:
                      Text('${job.jobInfo.companyRequirements.driversRequired}'),
                  prefix: const Text('Trucks Required'),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Goods Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                CupertinoFormRow(
                  child: Text(job.jobInfo.addressInformation.pickupInfo.contactName),
                  prefix: const Text('Importer'),
                ),
                CupertinoFormRow(
                  child: Text(job.jobInfo.addressInformation.dropOffInfo.contactName),
                  prefix: const Text('Exporter'),
                ),
                CupertinoFormRow(
                  child: Text(job.jobInfo.goodsInformation.commodity),
                  prefix: const Text('Commodity'),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Address Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                CupertinoFormRow(
                  child: Container(),
                  prefix: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Pickup'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SingleChildScrollView(
                          child: Text(
                            job.jobInfo.addressInformation.pickupInfo.address,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CupertinoFormRow(
                  child: Container(),
                  prefix: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Drop-off'),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SingleChildScrollView(
                          child: Text(
                            job.jobInfo.addressInformation.dropOffInfo.address,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Schedule Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                CupertinoFormRow(
                  child: Text(
                    Helpers.getDateTimeIntlFormat(
                        job.jobInfo.scheduleInformation.startTime),
                  ),
                  prefix: const Text('Pickup'),
                ),
                CupertinoFormRow(
                  child: Text(
                    Helpers.getDateTimeIntlFormat(
                        job.jobInfo.scheduleInformation.finishTime),
                  ),
                  prefix: const Text('Drop-off'),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Payment Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                CupertinoFormRow(
                  child: Text(
                    Helpers.getPaymentType(
                        job.jobInfo.paymentInformation.payType),
                  ),
                  prefix: const Text('Payment Type'),
                ),
                CupertinoFormRow(
                  child: Text(
                    '\$ ${job.jobInfo.paymentInformation.payRate}',
                  ),
                  prefix: const Text('Amount'),
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Special Instructions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20.0, 6.0, 6.0, 0),
                  child: Text(
                    job.jobInfo.specialInstructions.instructions,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ],
          footer: const Divider(),
        ),
      ),
    );
  }
}
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa