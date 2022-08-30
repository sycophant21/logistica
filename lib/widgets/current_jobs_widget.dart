import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/screens/goods_and_company_info_input_for_create_job_screen.dart';

import '../screens/job_details_screen.dart';

class CurrentJobs extends StatelessWidget {
  final List<Job> currentJobs;
  final Map<String, List<Job>> jobsByDispatchers = {};

  CurrentJobs({Key? key, required this.currentJobs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (var element in currentJobs) {
      if(jobsByDispatchers.containsKey(element.dispatcher.companyName)) {
        jobsByDispatchers[element.dispatcher.companyName]!.add(element);
      }
      else {
        jobsByDispatchers.putIfAbsent(element.dispatcher.companyName, () {
          return [element];
        });
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        children: jobsByDispatchers.keys.map((e) {
          return CupertinoFormSection(
            header: Text(e, style: const TextStyle(fontSize: 18),),
            children: jobsByDispatchers[e]!.map((a) {
              String importerName = a.jobInfo.addressInformation.pickupInfo.contactName;
              if(importerName.length > 15) {
                importerName = importerName.substring(0,15);
              }
              String exporterName = a.jobInfo.addressInformation.dropOffInfo.contactName;
              if(exporterName.length > 15) {
                exporterName = exporterName.substring(0,15);
              }
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return JobDetailsScreen(
                        job: a);
                  }));
                },
                child: Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (ctx) {
                          Navigator.of(context).push(CupertinoPageRoute(builder: (ctx) {
                            return GoodsAndCompanyInfoInputForCreateJobScreen(job: a,jobMode: JobMode.EDIT,);
                          }));
                        },
                        label: 'Edit',
                        icon: CupertinoIcons.pencil,
                        foregroundColor: CupertinoColors.darkBackgroundGray,
                        backgroundColor: CupertinoColors.systemOrange,
                      ),
                      SlidableAction(
                        onPressed: (ctx) {},
                        label: 'Cancel',
                        icon: CupertinoIcons.clear_circled,
                        foregroundColor: CupertinoColors.darkBackgroundGray,
                        backgroundColor: CupertinoColors.destructiveRed,
                      ),
                    ],
                  ),
                  child: ListTile(
                    trailing: Helpers.getIcon(a),
                    title: Text(
                      'Job #${a.id}',
                      style: const TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(47, 47, 47, 1)),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'Shipper   : ${a.jobInfo.addressInformation.pickupInfo.contactName.padRight(18, ' ')}(${Helpers.getTimeString(a.jobInfo.scheduleInformation.startTime)})\nDeliver To: ${exporterName.padRight(18, ' ')}(${Helpers.getTimeString(a.jobInfo.scheduleInformation.finishTime)})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}
//Commodity name, special instruction, importer/ exporter name