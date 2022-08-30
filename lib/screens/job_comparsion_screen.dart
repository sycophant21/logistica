/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/auth_service.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/models/driver_job_response.dart';
import 'package:test_123/models/job_comparison.dart';

class JobComparisonScreen extends StatefulWidget {
  final JobComparison jobs;

  const JobComparisonScreen({Key? key, required this.jobs})
      : super(key: key);

  @override
  _JobComparisonScreenState createState() => _JobComparisonScreenState();
}

class _JobComparisonScreenState extends State<JobComparisonScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  final APIHandler apiHandler = APIHandler.getAPIHandler();
  late AnimationController animationController;
  final List<Marker> markers = List.empty(growable: true);
  GoogleMapController? _controller;
  String newStartAddress = '';
  String oldStartAddress = '';
  String newEndAddress = '';
  String oldEndAddress = '';
  late DriverJobResponse driverJobResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverJobResponse = widget.jobs.previousJob.driverJobResponses.singleWhere((element) {
      return element.driver.userId.id == apiHandler.userId!.id;
    });
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(
              widget
                  .jobs.currentJob.jobInfo.addressInformation.startingCoOrdinates.latitude,
              widget.jobs.currentJob.jobInfo.addressInformation.startingCoOrdinates
                  .longitude),
          draggable: false,
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('1234'),
          position: LatLng(
              widget
                  .jobs.currentJob.jobInfo.addressInformation.finishingCoOrdinates.latitude,
              widget.jobs.currentJob.jobInfo.addressInformation.finishingCoOrdinates
                  .longitude),
          draggable: false,
        ),
      );
    });
    //animationController.duration = const Duration(seconds: 1);
    setAddress();
  }

  Future<void> setAddress() async {
    getAddress(Helpers.getLatLngFromCoordinates(
        widget.jobs.currentJob.jobInfo.addressInformation.startingCoOrdinates))
        .then((value) {
      setState(() {
        newStartAddress = value;
      });
    });
    getAddress(Helpers.getLatLngFromCoordinates(
        widget.jobs.previousJob.jobInfo.addressInformation.startingCoOrdinates))
        .then((value) {
      setState(() {
        oldStartAddress = value;
      });
    });
    getAddress(Helpers.getLatLngFromCoordinates(
        widget.jobs.currentJob.jobInfo.addressInformation.finishingCoOrdinates))
        .then((value) {
      setState(() {
        newEndAddress = value;
      });
    });
    getAddress(Helpers.getLatLngFromCoordinates(
        widget.jobs.previousJob.jobInfo.addressInformation.finishingCoOrdinates))
        .then((value) {
      setState(() {
        oldEndAddress = value;
      });
    });
  }

  Future<String> getAddress(LatLng latLng) async {
    String placeId = await APIHandler.getAPIHandler().getAddress(latLng);
    GoogleMapsPlaces _places = GoogleMapsPlaces(
      apiKey: Helpers.apiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(placeId);
    return detail.result.formattedAddress!;
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    setState(() {
      _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(
                    widget.jobs.currentJob.jobInfo.addressInformation.startingCoOrdinates
                        .latitude,
                    widget.jobs.currentJob.jobInfo.addressInformation.startingCoOrdinates
                        .longitude),
                northeast: LatLng(
                    widget.jobs.currentJob.jobInfo.addressInformation.finishingCoOrdinates
                        .latitude,
                    widget.jobs.currentJob.jobInfo.addressInformation.finishingCoOrdinates
                        .longitude)),
            1),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      extendBodyBehindAppBar: true,
      body: Container(
        constraints: BoxConstraints(
          maxHeight: (MediaQuery.of(context).size.height * 1 / 3),
        ),
        child: GoogleMap(
          onTap: (value) {},
          markers: Set.of(markers),
          myLocationEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition:
          const CameraPosition(target: LatLng(0, 0), zoom: 1),
          onMapCreated: _onMapCreated,
        ),
      ),
      bottomSheet: BottomSheet(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 2 / 3,
        ),
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 25,
              centerTitle: false,
              leading: CupertinoNavigationBarBackButton(
                onPressed: () {
                  if(Navigator.of(context).canPop()) {
                    Navigator.pop(context);
                  }
                  else {
                    Navigator.pushReplacementNamed(context, AuthService.route);
                  }
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Update in Job',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        'Previously ${driverJobResponse.driverJobStatus.name}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Id - ${widget.jobs.currentJob.jobId.jobId}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                      //color: Color.fromRGBO(27, 27, 27, 0.5),
                    ),
                  )
                ],
              ),
              actions: [
                CupertinoButton(
                  child: const Icon(
                    CupertinoIcons.check_mark_circled,
                    color: CupertinoColors.activeGreen,
                  ),
                  onPressed: () {
                    apiHandler
                        .changeJobAcceptanceStatus(widget.jobs.currentJob.jobId.jobId, true)
                        .then((value) {
                      if (value.statusCode == 200) {
                        Navigator.of(context)
                            .pushReplacementNamed(AuthService.route);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(value.message)));
                      }
                    });
                  },
                ),
                CupertinoButton(
                  child: const Icon(
                    CupertinoIcons.clear_circled_solid,
                    color: CupertinoColors.destructiveRed,
                  ),
                  onPressed: () {
                    apiHandler
                        .changeJobAcceptanceStatus(
                        widget.jobs.currentJob.jobId.jobId, false)
                        .then((value) {
                      if (value.statusCode == 200) {
                        Navigator.of(context)
                            .pushReplacementNamed(AuthService.route);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(value.message)));
                      }
                    });
                  },
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
              ),
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Pickup',
                              style: TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  Helpers.getDateTimeIntlFormat(widget
                                      .jobs.previousJob.jobInfo.scheduleInformation.startTime),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  Helpers.getDateTimeIntlFormat(widget
                                      .jobs.currentJob.jobInfo.scheduleInformation.startTime),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              oldStartAddress,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                            Text(
                              newStartAddress,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 14,
                                overflow: TextOverflow.fade,
                              ),
                            ),
                          ],
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Drop-off',
                              style: TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  Helpers.getDateTimeIntlFormat(widget
                                      .jobs.previousJob.jobInfo.scheduleInformation.finishTime),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  Helpers.getDateTimeIntlFormat(widget
                                      .jobs.currentJob.jobInfo.scheduleInformation.finishTime),
                                  style: const TextStyle(
                                    color: Color.fromRGBO(27, 27, 27, 1),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Text(
                              oldEndAddress,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              newEndAddress,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 14,
                              ),
                            ),
                          ],
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
                        CupertinoFormRow(
                          child: Row(
                            children: [
                              Text(
                                widget.jobs.previousJob.jobInfo.goodsInformation.commodity,
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                widget.jobs.currentJob.jobInfo.goodsInformation.commodity,
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
                        CupertinoFormRow(
                          child: Row(
                            children: [
                              Text(
                                '${widget.jobs.previousJob.jobInfo.goodsInformation.totalWeight} lbs',
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '${widget.jobs.currentJob.jobInfo.goodsInformation.totalWeight} lbs',
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          prefix: const Text(
                            'Total Weight',
                            style: TextStyle(
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontSize: 16,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Description',
                              style: TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              widget.jobs.previousJob.jobInfo.goodsInformation.description,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough,
                              ),
                              maxLines: 5,
                            ),
                            Text(
                              widget.jobs.currentJob.jobInfo.goodsInformation.description,
                              style: const TextStyle(
                                color: Color.fromRGBO(27, 27, 27, 1),
                                fontSize: 14,
                              ),
                              maxLines: 5,
                            ),
                          ],
                        ),
                        */
/*CupertinoFormRow(
                          child: Text(
                            widget.job.jobInfo.goodsInformation.description,
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontSize: 14,
                            ),
                          ),
                          prefix: const Text(
                            'Description',
                            style: TextStyle(
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontSize: 16,
                            ),
                          ),
                          padding: EdgeInsets.zero,
                        ),*//*

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
                          child: Row(
                            children: [
                              Text(
                                widget.jobs.previousJob.jobInfo.paymentInformation.payType.name,
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                widget.jobs.currentJob.jobInfo.paymentInformation.payType.name,
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
                          child: Row(
                            children: [
                              Text(
                                '\$ ${widget.jobs.previousJob.jobInfo.paymentInformation.payRate}',
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                '\$ ${widget.jobs.currentJob.jobInfo.paymentInformation.payRate}',
                                style: const TextStyle(
                                  color: Color.fromRGBO(27, 27, 27, 1),
                                  fontSize: 14,
                                ),
                              ),
                            ],
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
                          widget.jobs.previousJob.jobInfo.specialInstructions.instructions,
                          maxLines: 10,
                          style: const TextStyle(
                            color: Color.fromRGBO(27, 27, 27, 1),
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        Text(
                          widget.jobs.currentJob.jobInfo.specialInstructions.instructions,
                          maxLines: 10,
                          style: const TextStyle(
                            color: Color.fromRGBO(27, 27, 27, 1),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onClosing: () {},
        enableDrag: false,
      ),
    );
  }
}
*/
