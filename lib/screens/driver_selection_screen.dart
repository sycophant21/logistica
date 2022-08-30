import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/auth_service.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/helpers/selected_driver.dart';
import 'package:test_123/models/driver.dart';
import 'package:test_123/models/driver_job_response.dart';
import 'package:test_123/models/driver_job_status.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/screens/home.dart';

import '../models/job_status.dart';

class DriverSelectionScreen extends StatefulWidget {
  static const String route = '/driverSelection';
  final Job job;
  final JobMode jobMode;

  const DriverSelectionScreen({Key? key, required this.job, required this.jobMode}) : super(key: key);

  @override
  _DriverSelectionScreenState createState() => _DriverSelectionScreenState();
}

class _DriverSelectionScreenState extends State<DriverSelectionScreen> {
  final List<SelectedDriver> selectedDrivers = List.empty(growable: true);
  final APIHandler apiHandler = APIHandler.getAPIHandler();
  bool isSelected = false;
  int selected = 0;
  bool gettingDrivers = false;
  bool isCreatingJob = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDrivers();
  }

  Future<void> getDrivers() async {
    setState(() {
      gettingDrivers = true;
    });
    apiHandler.getDrivers().then((drivers) {
      setState(() {
        for (Driver d in drivers) {
          selectedDrivers.add(SelectedDriver(
              d,
              widget.job.driverJobResponses.contains(
                  DriverJobResponse('', d, DriverJobStatus.NO_RESPONSE))));
        }
        gettingDrivers = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drivers'),
        leading: const CupertinoNavigationBarBackButton(),
        actions: [
          isCreatingJob
              ? const CircularProgressIndicator.adaptive()
              : widget.job.jobStatus == JobStatus.ACQUIRING_INFO
                  ? CupertinoButton(
                      child: const Text('Create'),
                      onPressed: () {
                        setState(() {
                          if (selected > 0) {
                            widget.job.jobStatus =
                                JobStatus.WAITING_FOR_DRIVER_CONFIRMATION;
                            widget.job.driverJobResponses
                                .addAll(selectedDrivers.where((element) {
                              return element.isSelected = true;
                            }).map((e) {
                              return DriverJobResponse(null, e.driver,
                                  DriverJobStatus.REQUEST_NOT_SENT);
                            }));
                          } else {
                            widget.job.jobStatus = JobStatus.CREATED;
                          }
                          isCreatingJob = true;
                          apiHandler.createJob(widget.job).then((value) {
                            showCupertinoModalPopup(
                                barrierDismissible: false,
                                context: context,
                                builder: (ctx) {
                                  return CupertinoAlertDialog(
                                    title: const Text('Job Created'),
                                    content: Row(
                                      children: const [
                                        Text(
                                            'Job has been created successfully.'),
                                      ],
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).popUntil(
                                              ModalRoute.withName(Home.route));
                                          Navigator.of(context).pop();
                                          Navigator.of(context)
                                              .pushNamed(AuthService.route);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          });
                        });
                      })
                  : CupertinoButton(
                      onPressed: () {
                        //apiHandler.addDriversToJob()
                      },
                      child: const Text('Done'),
                    ),
        ],
      ),
      body: gettingDrivers
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : selectedDrivers.isNotEmpty
              ? ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shrinkWrap: true,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: selectedDrivers.isNotEmpty
                          ? TextButton(
                              onPressed: () {
                                setState(() {
                                  bool currentStatus =
                                      isSelected ? false : true;
                                  for (var element in selectedDrivers) {
                                    changeSelectedStatus(
                                        currentStatus, element);
                                  }
                                });
                              },
                              child: Text(
                                !isSelected ? 'Select All' : 'Deselect All',
                                style: const TextStyle(
                                    color: Color.fromRGBO(47, 47, 47, 1)),
                              ),
                              style: TextButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                splashFactory: InkRipple.splashFactory,
                              ),
                            )
                          : null,
                    ),
                    ListView(
                      shrinkWrap: true,
                      children: selectedDrivers.map((e) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Card(
                            elevation: 2,
                            child: CheckboxListTile(
                              checkColor: Colors.white,
                              activeColor: const Color.fromRGBO(47, 47, 47, 1),
                              title: Text(
                                e.driver.personalUserInfo.name,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(47, 47, 47, 1)),
                              ),
                              subtitle: Text(e.driver.userId.id),
                              value: e.isSelected,
                              onChanged: widget.jobMode == JobMode.EDIT ? null : (bool? value) {
                                setState(() {
                                  changeSelectedStatus(value!, e);
                                });
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                      'Nothing to see here.\nAdd Drivers first to create a job.'),
                ),
    );
  }

  void changeSelectedStatus(bool value, SelectedDriver selectedDriver) {
    if (value && !selectedDriver.isSelected) {
      selected++;
      selectedDriver.isSelected = true;
    } else if (!value && selectedDriver.isSelected) {
      selected--;
      selectedDriver.isSelected = false;
    }
    if (selected == selectedDrivers.length) {
      selected = selectedDrivers.length;
      isSelected = true;
    } else {
      isSelected = false;
    }
  }
}
