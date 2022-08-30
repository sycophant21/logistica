import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/helpers/selected_place_details.dart';
import 'package:test_123/models/address_information.dart';
import 'package:test_123/models/co_ordinates.dart';
import 'package:test_123/models/delivery_information.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/schedule_information.dart';
import 'package:test_123/screens/payment_info_input_for_create_job_screen.dart';
import 'package:test_123/widgets/place_selection_bottom_sheet.dart';

class AddressInfoInputForCreateJobScreen extends StatefulWidget {
  final Job job;
  final JobMode jobMode;

  const AddressInfoInputForCreateJobScreen(
      {Key? key, required this.job, required this.jobMode})
      : super(key: key);

  @override
  State<AddressInfoInputForCreateJobScreen> createState() =>
      _AddressInfoInputForCreateJobScreenState();
}

class _AddressInfoInputForCreateJobScreenState
    extends State<AddressInfoInputForCreateJobScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime = DateTime.now().add(const Duration(hours: 6));
  DateTime currentDateTime = DateTime.now();
  final TextEditingController startPointController = TextEditingController();
  String startPointContactName = '';
  String endPointContactName = '';
  String startPointContactNumber = '';
  String endPointContactNumber = '';
  final TextEditingController dropPointController = TextEditingController();
  final TextEditingController startDateAndTimeController =
      TextEditingController();
  final TextEditingController endDateAndTimeController =
      TextEditingController();
  SelectedPlaceDetails? selectedStartPlaceDetails;
  SelectedPlaceDetails? selectedDropPlaceDetails;

  @override
  void initState() {
    super.initState();
    if (widget.jobMode == JobMode.EDIT) {
      startPointController.text =
          widget.job.jobInfo.addressInformation.pickupInfo.address;
      dropPointController.text =
          widget.job.jobInfo.addressInformation.dropOffInfo.address;
      startDateAndTimeController.text = Helpers.getDateTimeIntlFormat(
          widget.job.jobInfo.scheduleInformation.startTime);
      endDateAndTimeController.text = Helpers.getDateTimeIntlFormat(
          widget.job.jobInfo.scheduleInformation.finishTime);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _formKey.currentState!.dispose();
    startPointController.dispose();
    dropPointController.dispose();
    startDateAndTimeController.dispose();
    endDateAndTimeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CupertinoNavigationBarBackButton(),
        title: const Text('New Job'),
        actions: [
          CupertinoButton(
              child: const Text('Next'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (widget.jobMode == JobMode.CREATE) {
                    AddressInformation addressInformation =
                        widget.job.jobInfo.addressInformation;

                    DeliveryInformation pickupInfo =
                        addressInformation.pickupInfo;
                    pickupInfo.contactNumber = startPointContactNumber;
                    pickupInfo.address = selectedStartPlaceDetails!
                        .placeDetails.formattedAddress!;
                    pickupInfo.coOrdinates = CoOrdinates(
                      selectedStartPlaceDetails!.latLng.longitude,
                      selectedStartPlaceDetails!.latLng.latitude,
                    );

                    DeliveryInformation dropOffInfo =
                        addressInformation.dropOffInfo;
                    dropOffInfo.contactNumber = endPointContactNumber;
                    dropOffInfo.address = selectedDropPlaceDetails!
                        .placeDetails.formattedAddress!;
                    dropOffInfo.coOrdinates = CoOrdinates(
                      selectedDropPlaceDetails!.latLng.longitude,
                      selectedDropPlaceDetails!.latLng.latitude,
                    );

                    widget.job.jobInfo.scheduleInformation =
                        ScheduleInformation(startDateTime, endDateTime);
                  }
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return PaymentInfoInputForCreateJobScreen(
                          job: widget.job,
                          jobMode: widget.jobMode,
                        );
                      },
                    ),
                  );
                }
              }),
        ],
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      body: Form(
        key: _formKey,
        child: CupertinoFormSection(
          margin: EdgeInsets.zero,
          header: const Text(
            'Location Details',
            style: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          children: [
            CupertinoFormSection(
              header: const Text(
                'Pickup Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                CupertinoTextFormFieldRow(
                  readOnly: true,
                  enabled: widget.jobMode == JobMode.CREATE,
                  enableInteractiveSelection: false,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  controller: startPointController,
                  onTap: () async {
                    showCupertinoModalBottomSheet<SelectedPlaceDetails>(
                      context: context,
                      builder: (BuildContext context) {
                        //selectedStartPlaceDetails = null;
                        return PlaceSelectionBottomSheet();
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          selectedStartPlaceDetails = value;
                          startPointController.text = selectedStartPlaceDetails!
                              .placeDetails.formattedAddress!;
                        });
                      }
                    });
                  },
                  validator: widget.jobMode == JobMode.EDIT
                      ? null
                      : (value) {
                          if (startPointController.text.isEmpty) {
                            return 'This field can not be empty';
                          }
                        },
                  placeholder: 'Pick up Point',
                  placeholderStyle: TextStyle(
                      fontSize: 18, color: Colors.grey.withOpacity(0.75)),
                  prefix: const Icon(
                    CupertinoIcons.location_solid,
                    size: 28,
                    color: Colors.red,
                  ),
                ),
                CupertinoTextFormFieldRow(
                  readOnly: true,
                  enabled: widget.jobMode == JobMode.CREATE,
                  enableInteractiveSelection: false,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  prefix: const Icon(
                    CupertinoIcons.time,
                    color: Color.fromRGBO(27, 27, 27, 1),
                  ),
                  placeholder: DateFormat.MMM()
                      .add_d()
                      .add_y()
                      .add_jm()
                      .format(startDateTime),
                  placeholderStyle:
                      TextStyle(color: Colors.grey.withOpacity(0.75)),
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.25,
                            color: Colors.white,
                            child: CupertinoDatePicker(
                              onDateTimeChanged: (value) {
                                setState(() {
                                  startDateTime = value;
                                  endDateTime = startDateTime
                                      .add(const Duration(hours: 6));
                                  startDateAndTimeController.text =
                                      DateFormat.MMM()
                                          .add_d()
                                          .add_y()
                                          .add_jm()
                                          .format(startDateTime);
                                  endDateAndTimeController.text =
                                      DateFormat.MMM()
                                          .add_d()
                                          .add_y()
                                          .add_jm()
                                          .format(endDateTime);
                                });
                              },
                              dateOrder: DatePickerDateOrder.mdy,
                              initialDateTime: startDateTime,
                              minimumDate: currentDateTime
                                  .subtract(const Duration(seconds: 1)),
                              maximumDate:
                                  currentDateTime.add(const Duration(days: 30)),
                            ),
                          );
                        });
                  },
                  controller: startDateAndTimeController,
                  onSaved: widget.jobMode == JobMode.EDIT
                      ? null
                      : (value) {
                          setState(() {
                            startDateAndTimeController.text =
                                Helpers.getDateTimeString(startDateTime);
                            //startDateTime = DateTime.parse(value!);
                          });
                        },
                  validator: widget.jobMode == JobMode.EDIT
                      ? null
                      : (value) {
                          try {
                            DateTime d =
                                DateFormat('MMM d y hh:mm a').parse(value!);
                            if (d.isBefore(DateTime.now())) {
                              return 'Pick up date can not belong to the past';
                            }
                            return null;
                          } catch (e) {
                            return 'Enter a valid Date & Time';
                          }
                        },
                ),
              ],
            ),
            CupertinoFormSection(
              header: const Text(
                'Drop-off Details',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              children: [
                CupertinoTextFormFieldRow(
                  readOnly: true,
                  enabled: widget.jobMode == JobMode.CREATE,
                  enableInteractiveSelection: false,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  controller: dropPointController,
                  onTap: () async {
                    showCupertinoModalBottomSheet<SelectedPlaceDetails>(
                      context: context,
                      builder: (BuildContext context) {
                        return PlaceSelectionBottomSheet();
                      },
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          selectedDropPlaceDetails = value;
                          dropPointController.text = selectedDropPlaceDetails!
                              .placeDetails.formattedAddress!;
                        });
                      }
                    });
                  },
                  validator: widget.jobMode == JobMode.EDIT
                      ? null
                      : (value) {
                          if (dropPointController.text.isEmpty) {
                            return 'This field can not be empty';
                          }
                        },
                  placeholder: 'Drop off Point',
                  placeholderStyle: TextStyle(
                      fontSize: 18, color: Colors.grey.withOpacity(0.75)),
                  prefix: const Icon(
                    CupertinoIcons.location_solid,
                    size: 28,
                    color: Colors.red,
                  ),
                ),
                CupertinoTextFormFieldRow(
                  readOnly: true,
                  enabled: widget.jobMode == JobMode.CREATE,
                  enableInteractiveSelection: false,
                  prefix: const Icon(
                    CupertinoIcons.time,
                    color: Color.fromRGBO(27, 27, 27, 1),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  controller: endDateAndTimeController,
                  placeholder: DateFormat.MMM()
                      .add_d()
                      .add_y()
                      .add_jm()
                      .format(endDateTime),
                  placeholderStyle:
                      TextStyle(color: Colors.grey.withOpacity(0.75)),
                  onTap: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.25,
                            color: Colors.white,
                            child: CupertinoDatePicker(
                              mode: CupertinoDatePickerMode.dateAndTime,
                              onDateTimeChanged: (value) {
                                endDateTime = value;
                                endDateAndTimeController.text = DateFormat.MMM()
                                    .add_d()
                                    .add_y()
                                    .add_jm()
                                    .format(endDateTime);
                              },
                              initialDateTime: endDateTime,
                              minimumDate: startDateTime
                                  .subtract(const Duration(seconds: 1)),
                              maximumDate:
                                  startDateTime.add(const Duration(days: 30)),
                            ),
                          );
                        });
                  },
                  onSaved: widget.jobMode == JobMode.EDIT
                      ? null
                      : (value) {
                          setState(() {
                            endDateAndTimeController.text =
                                Helpers.getDateTimeString(endDateTime);
                            //endDateTime = DateTime.parse(value!);
                          });
                        },
                  validator: widget.jobMode == JobMode.EDIT
                      ? null
                      : (value) {
                          try {
                            DateTime d =
                                DateFormat('MMM d y hh:mm a').parse(value!);
                            if (d.isBefore(DateTime.now()) ||
                                d.isAtSameMomentAs(DateTime.now())) {
                              return 'Drop off date must be after the current date';
                            }
                            return null;
                          } catch (e) {
                            return 'Enter a valid Date & Time';
                          }
                        },
                ),
              ],
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
