import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/main.dart';
import 'package:test_123/screens/home.dart';
import 'package:test_123/screens/job_acceptance_screen.dart';
import 'package:test_123/screens/job_comparsion_screen.dart';
import 'package:test_123/screens/job_details_screen.dart';
import 'package:test_123/screens/login.dart';

class AuthService extends StatefulWidget {
  static const String route = '/authService';
  final FirebaseMessaging fcm;

  const AuthService({Key? key, required this.fcm}) : super(key: key);

  @override
  _AuthServiceState createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  final APIHandler _apiHandler = APIHandler.getAPIHandler();
  final BehaviorSubject<RemoteMessage> _jobsStreamController =
  Helpers.jobsStreamController;
  final BehaviorSubject<RemoteMessage> _networkStreamController =
      Helpers.networkStreamController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialise();
  }

  Future<void> getUser() async {
    Helpers.getUser().then((value) {
      if (value != null) {
        _apiHandler.getUser(value.sessionId).then((value) {
          Navigator.of(context).pushReplacementNamed(Home.route);
        });
      }
      else {
        Navigator.of(context).pushReplacementNamed(Login.route);
      }
    });

  }

  Future initialise() async {
    if (Platform.isIOS) {
      await widget.fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }

    _apiHandler.deviceInfo = (await widget.fcm.getToken())!;
    print(_apiHandler.deviceInfo);
    getUser();
    FirebaseMessaging.instance.subscribeToTopic('topic');
    FirebaseMessaging.onMessage.listen((RemoteMessage rm) {
      Map<String, dynamic> data = rm.data;
      if (data.containsKey('notification_type')) {
        String notificationType = data['notification_type'];
        if (notificationType == 'new_job') {
          _jobsStreamController.sink.add(rm);
        } else {
          _networkStreamController.sink.add(rm);
        }
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        if (value.data.containsKey('notification_type')) {
          String notificationType = value.data['notification_type'];
          if (notificationType == 'new_job') {
            _apiHandler.getJob(value.data['job_id']).then((value) {
              Navigator.of(MyApp.navigatorKey.currentContext!).pushReplacement(CupertinoPageRoute(builder: (ctx) {
                return JobAcceptanceScreen(job: value);
              }));
            });
          } else if (notificationType == 'update_job') {
            _apiHandler
                .getJobsForComparison(value.data['job_id'])
                .then((value) {
              Navigator.of(MyApp.navigatorKey.currentContext!).push(CupertinoPageRoute(builder: (ctx) {
                return Container();
              }));
            });
          }
        }
      }
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      _apiHandler.sendToken(event);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage rm) async {
      if (rm.data.containsKey('notification_type')) {
        String notificationType = rm.data['notification_type'];
        //if (notificationType == 'invitation') {
          //String invitationType = rm.data['invitation_type'];
          if (notificationType == 'new_job') {
            await _apiHandler.getJob(rm.data['job_id']).then((value) {
              Navigator.of(MyApp.navigatorKey.currentContext!).push(CupertinoPageRoute(builder: (ctx) {
                return JobAcceptanceScreen(job: value);
              }));
            });
          } else if (notificationType == 'update_job') {
            _apiHandler.getJobsForComparison(rm.data['job_id']).then((value) {
              Navigator.of(MyApp.navigatorKey.currentContext!).push(CupertinoPageRoute(builder: (ctx) {
                return Container();
              }));
            });
          }
        //}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
//
