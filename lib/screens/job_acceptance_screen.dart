import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/auth_service.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/job_acceptance_status.dart';

class JobAcceptanceScreen extends StatefulWidget {
  final Job job;

  const JobAcceptanceScreen({Key? key, required this.job})
      : super(key: key);

  @override
  _JobAcceptanceScreenState createState() => _JobAcceptanceScreenState();
}

class _JobAcceptanceScreenState extends State<JobAcceptanceScreen>
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
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(
              widget
                  .job.jobInfo.addressInformation.pickupInfo.coOrdinates.latitude,
              widget.job.jobInfo.addressInformation.pickupInfo.coOrdinates
                  .longitude),
          draggable: false,
        ),
      );
      markers.add(
        Marker(
          markerId: const MarkerId('1234'),
          position: LatLng(
              widget
                  .job.jobInfo.addressInformation.dropOffInfo.coOrdinates.latitude,
              widget.job.jobInfo.addressInformation.dropOffInfo.coOrdinates
                  .longitude),
          draggable: false,
        ),
      );
    });
    //animationController.duration = const Duration(seconds: 1);
  }


  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    setState(() {
      _controller!.animateCamera(
        CameraUpdate.newLatLngBounds(
            LatLngBounds(
                southwest: LatLng(
                    widget.job.jobInfo.addressInformation.pickupInfo.coOrdinates
                        .latitude,
                    widget.job.jobInfo.addressInformation.pickupInfo.coOrdinates
                        .longitude),
                northeast: LatLng(
                    widget.job.jobInfo.addressInformation.dropOffInfo.coOrdinates
                        .latitude,
                    widget.job.jobInfo.addressInformation.dropOffInfo.coOrdinates
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
              leadingWidth: 35,
              centerTitle: false,
              leading: CupertinoNavigationBarBackButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, AuthService.route);
                },
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Job',
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
                CupertinoButton(
                  child: const Icon(
                    CupertinoIcons.check_mark_circled,
                    color: CupertinoColors.activeGreen,
                  ),
                  onPressed: () {
                    apiHandler
                        .changeJobAcceptanceStatus(widget.job.jobId.jobId, JobAcceptanceStatus.ACCEPTED)
                        .then((value) {
                      if (value.statusCode == 200 && value.message == 'SUCCESS') {
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
                            widget.job.jobId.jobId, JobAcceptanceStatus.REJECTED)
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
                            Text(
                              Helpers.getDateTimeIntlFormat(widget
                                  .job.jobInfo.scheduleInformation.startTime),
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
                          widget.job.jobInfo.addressInformation.pickupInfo.address,
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
                            Text(
                              Helpers.getDateTimeIntlFormat(widget
                                  .job.jobInfo.scheduleInformation.finishTime),
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
                          widget.job.jobInfo.addressInformation.dropOffInfo.address,
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
                        CupertinoFormRow(
                          child: Text(
                            widget.job.jobInfo.goodsInformation.commodity,
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
                        CupertinoFormRow(
                          child: Text(
                            '${widget.job.jobInfo.goodsInformation.totalWeight} lbs',
                            style: const TextStyle(
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontSize: 14,
                            ),
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
                        CupertinoFormRow(
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
                            widget.job.jobInfo.paymentInformation.payType.name,
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
                          widget.job.jobInfo.specialInstructions.instructions,
                          maxLines: 10,
                        )
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
