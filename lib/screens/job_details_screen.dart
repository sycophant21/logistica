import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/user_type.dart';
import 'package:test_123/screens/driver_selection_screen.dart';

class JobDetailsScreen extends StatefulWidget {
  final Job job;

  const JobDetailsScreen({Key? key, required this.job})
      : super(key: key);

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final APIHandler apiHandler = APIHandler.getAPIHandler();
  late AnimationController animationController;
  final List<Marker> markers = List.empty(growable: true);
  GoogleMapController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(
              widget.job.jobInfo.addressInformation.pickupInfo.coOrdinates
                  .latitude,
              widget.job.jobInfo.addressInformation.pickupInfo.coOrdinates
                  .longitude),
          draggable: false,
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('1234'),
          position: LatLng(
              widget.job.jobInfo.addressInformation.dropOffInfo.coOrdinates
                  .latitude,
              widget.job.jobInfo.addressInformation.dropOffInfo.coOrdinates
                  .longitude),
          draggable: false,
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    setState(() {
      LatLng l1 = LatLng(
          widget.job.jobInfo.addressInformation.pickupInfo.coOrdinates.latitude,
          widget
              .job.jobInfo.addressInformation.pickupInfo.coOrdinates.longitude);
      LatLng l2 = LatLng(
          widget
              .job.jobInfo.addressInformation.dropOffInfo.coOrdinates.latitude,
          widget.job.jobInfo.addressInformation.dropOffInfo.coOrdinates
              .longitude);
      LatLng southwest;
      LatLng northeast;
      if (l1.latitude > l2.latitude) {
        southwest = l2;
        northeast = l1;
      } else {
        northeast = l2;
        southwest = l1;
      }

      _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(southwest: southwest, northeast: northeast), 1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: Container(
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height * 1 / 3),
        ),
        child: GoogleMap(
          indoorViewEnabled: true,
          trafficEnabled: true,
          padding: const EdgeInsets.symmetric(vertical: 48),
          onTap: (value) {},
          markers: Set.of(markers),
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition:
              const CameraPosition(target: LatLng(0, 0), zoom: 1),
          onMapCreated: _onMapCreated,
        ),
      ),
      bottomSheet: BottomSheet(
        elevation: 2,
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height * 2 / 3),
        ),
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 25,
              centerTitle: false,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Details',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Id - ${widget.job.jobId.jobId}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                      //color: Color.fromRGBO(27, 27, 27, 0.5),
                    ),
                  )
                ],
              ),
              actions: [
                Visibility(
                  visible: apiHandler.currentUserType == UserType.DISPATCHER,
                  child: CupertinoButton(
                    child: const Text('Add drivers'),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                        return DriverSelectionScreen(job: widget.job, jobMode: JobMode.EDIT,);
                      }));
                    },
                  ),
                ),
              ],
            ),
            body: CupertinoTabScaffold(
              tabBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                    ),
                    child: ListView(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Company Information',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CupertinoFormRow(
                                child: Text(
                                  widget.job.dispatcher.companyName,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                                prefix: const Text(
                                  'Company',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              CupertinoFormRow(
                                child: Text(
                                  '${widget.job.jobInfo.companyRequirements.driversRequired}',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                                prefix: const Text(
                                  'Drivers Required',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: 16.0, top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Pickup',
                                    style: TextStyle(
                                      color: Color.fromRGBO(27, 27, 27, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Helpers.getDateTimeIntlFormat(widget
                                        .job
                                        .jobInfo
                                        .scheduleInformation
                                        .startTime),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(27, 27, 27, 1),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.job.jobInfo.addressInformation
                                    .pickupInfo.address,
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Drop-off',
                                    style: TextStyle(
                                      color: Color.fromRGBO(27, 27, 27, 1),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    Helpers.getDateTimeIntlFormat(widget
                                        .job
                                        .jobInfo
                                        .scheduleInformation
                                        .finishTime),
                                    style: const TextStyle(
                                      color: Color.fromRGBO(27, 27, 27, 1),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                widget.job.jobInfo.addressInformation
                                    .dropOffInfo.address,
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Goods Information',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CupertinoFormRow(
                                child: Text(
                                  widget
                                      .job.jobInfo.goodsInformation.commodity,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                                prefix: const Text(
                                  'Commodity',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Payment Details',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              CupertinoFormRow(
                                child: Text(
                                  widget.job.jobInfo.paymentInformation
                                      .payType.name,
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                                prefix: const Text(
                                  'Payment',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              CupertinoFormRow(
                                child: Text(
                                  '\$ ${widget.job.jobInfo.paymentInformation.payRate}',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                                prefix: const Text(
                                  'Pay Rate',
                                  style: TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 16,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Special Instructions',
                                style: TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                widget.job.jobInfo.specialInstructions
                                    .instructions,
                                maxLines: 10,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.zero,
                    child: ListView(
                      children: widget.job.driverJobResponses.map(
                        (e) {
                          return CupertinoFormRow(
                            child: Text(e.driverJobStatus.name),
                            prefix: ListTile(
                              title: Text(e.driver.personalUserInfo.name),
                              subtitle: Text(e.driver.licenseNumber),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  );
                }
              },
              tabBar: CupertinoTabBar(
                height: 60,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.briefcase),
                      label: 'Job Info'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.group),
                      label: 'Drivers Info'),
                ],
              ),
            ),
          );
        },
        onClosing: () {},
        enableDrag: true,
        animationController: animationController,
      ),
    );
  }
}
