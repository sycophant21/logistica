import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:test_123/helpers/api_response.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/invitation_response.dart';
import 'package:test_123/helpers/job_acceptance.dart';
import 'package:test_123/models/dispatcher.dart';
import 'package:test_123/models/driver.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/job_acceptance_status.dart';
import 'package:test_123/models/job_comparison.dart';
import 'package:test_123/models/login_variables.dart';
import 'package:test_123/models/new_dispatcher_info.dart';
import 'package:test_123/models/new_driver_info.dart';
import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/session.dart';
import 'package:test_123/models/user_id.dart';
import 'package:test_123/models/user_type.dart';

class APIHandler {
  static APIHandler? _apiHandler;
  UserId? userId;
  PersonalUserInfo? personalUserInfo;
  String? deviceInfo;
  String? sessionId;
  final String _host = 'angular-century-346316.wl.r.appspot.com';
  bool isInitialised = false;
  UserType? currentUserType;

  APIHandler._();

  Future<void> getUserFromSP() async {
    await Helpers.getUser().then((value) {
      if (value != null) {
        sessionId = value.sessionId;
      }
    });
  }

  static APIHandler getAPIHandler() {
    _apiHandler ??= APIHandler._();
    _apiHandler?.getUserFromSP();
    return _apiHandler!;
  }

  Future<Session> login(String userId, String password) async {
    var response = await http.put(Uri.https(_host, '/user/login'),
        body: jsonEncode(LoginVariables(userId, password, deviceInfo!),
            toEncodable: (obj) {
          return LoginVariables.toJson(obj as LoginVariables);
        }),
        headers: {'Content-Type': 'application/json'});
    String body = response.body;
    Session session = Session.fromJson(jsonDecode(body));
    sessionId = session.sessionId.sessionId;
    Helpers.setUser(sessionId!);
    this.userId = session.personalUserInfo.userId;
    personalUserInfo = session.personalUserInfo;
    currentUserType = personalUserInfo!.userType == UserType.BOTH
        ? UserType.DISPATCHER
        : personalUserInfo!.userType;
    isInitialised = true;
    return session;
  }

  Future<PersonalUserInfo> getUser(String sessionId) async {
    var response = await http.get(
        Uri.https(_host, '/user/retrieveUser',
            {'sessionId': sessionId, 'deviceInfo': deviceInfo}),
        headers: {'sessionId': this.sessionId!});
    String body = response.body;
    if (response.statusCode == 200) {
      PersonalUserInfo personalUserInfo =
          PersonalUserInfo.fromJson(jsonDecode(body));
      userId = personalUserInfo.userId;
      this.personalUserInfo = personalUserInfo;
      currentUserType = personalUserInfo.userType == UserType.BOTH
          ? UserType.DISPATCHER
          : personalUserInfo.userType;
      isInitialised = true;
      return personalUserInfo;
    } else {
      throw Exception('Failed to get user');
    }
  }

  Future<Dispatcher> dispatcherSignup(NewDispatcherInfo creationObject) async {
    var response =
        await http.put(Uri.https(_host, '/dispatcher/addNewDispatcher'),
            body: jsonEncode(creationObject, toEncodable: (obj) {
              return NewDispatcherInfo.toJson(obj as NewDispatcherInfo);
            }),
            headers: {'Content-Type': 'application/json'});
    String body = response.body;
    Dispatcher distributor = Dispatcher.fromJson(jsonDecode(body));
    userId = distributor.userId;
    personalUserInfo = distributor.personalUserInfo;
    currentUserType = personalUserInfo!.userType == UserType.BOTH
        ? UserType.DISPATCHER
        : personalUserInfo!.userType;
    //isInitialised = true;
    return distributor;
  }

  Future<bool> driverSignup(NewDriverInfo creationObject) async {
    var response = await http.put(Uri.https(_host, '/driver/addNewDriver'),
        body: jsonEncode(creationObject, toEncodable: (obj) {
          return NewDriverInfo.toJson(obj as NewDriverInfo);
        }),
        headers: {'Content-Type': 'application/json'});
    String body = response.body;
    Driver driver = Driver.fromJson(jsonDecode(body));
    userId = driver.userId;
    personalUserInfo = driver.personalUserInfo;
    currentUserType = UserType.DRIVER;
    isInitialised = true;
    return driver.personalUserInfo.initialised;
  }

  Future<List<Job>> getJobs(DateTime jobDate) async {
    String path = '/${currentUserType!.name.toLowerCase()}/getJobs';
    String jobDateString =
        '${jobDate.year}-${jobDate.month.toString().padLeft(2, '0')}-${jobDate.day.toString().padLeft(2, '0')}'; //2011-12-03
    var response = await http.get(
        Uri.https(
            _host, path, {'userId': userId!.id, 'jobDate': jobDateString}),
        headers: {'sessionId': sessionId!});
    if (response.statusCode == 200) {
      String body = response.body;
      List<dynamic> dynamicJobs = jsonDecode(body);
      List<Job> jobs = List.empty(growable: true);
      for (dynamic d in dynamicJobs) {
        jobs.add(Job.fromJson(d));
      }
      return jobs;
    } else {
      return Future.error('Something unexpected happened.');
      //return List.empty();
    }
  }

  Future<List<PersonalUserInfo>> getPrivateNetwork() async {
    String path = '/${currentUserType!.name.toLowerCase()}/getPrivateNetwork';
    var response = await http.get(
        Uri.https(_host, path, {'userId': userId!.id}),
        headers: {'sessionId': sessionId!});
    if (response.statusCode == 200) {
      String body = response.body;
      List<dynamic> dynamicUsers = jsonDecode(body);
      List<PersonalUserInfo> users = List.empty(growable: true);
      for (dynamic d in dynamicUsers) {
        users.add(PersonalUserInfo.fromJson(d));
      }
      return users;
    }
    return Future.error('Something unexpected happened.');
  }

  Future<String> getAddress(LatLng latLng) async {
    var response = await http
        .get(Uri.https('maps.googleapis.com', 'maps/api/geocode/json', {
      'latlng': '${latLng.latitude},${latLng.longitude}',
      'key': 'AIzaSyAazC9z06b5xIYHvXrbVHVJNOaKSmRme28'
    }));
    String body = response.body;
    List<dynamic> list = jsonDecode(body)['results'];
    return list.first['place_id'];
  }

  Future<bool> addDispatcher(String userConnectionCode) async {
    String path = '/driver/addUserToPrivateNetwork';
    var response = await http.put(
      Uri.https(
        _host,
        path,
        {
          'userId': userId!.id,
          'connectionCode': userConnectionCode,
        },
      ),
      headers: {'sessionId': sessionId!},
    );
    String body = response.body;
    return jsonDecode(body)['statusCode'] == 200;
  }

  Future<InvitationResponse> addDriver(String emailId) async {
    String path = '/dispatcher/addUserToPrivateNetwork';
    var response = await http.put(
      Uri.https(
        _host,
        path,
        {
          'userId': userId!.id,
          'emailId': emailId,
        },
      ),
      headers: {'sessionId': sessionId!},
    );
    String body = response.body;
    return InvitationResponse.fromJson(jsonDecode(body));
  }

  Future<List<Driver>> getDrivers() async {
    String path = '/dispatcher/getDrivers';
    var response = await http.get(
      Uri.https(_host, path, {'userId': userId!.id}),
      headers: {'sessionId': sessionId!},
    );
    String body = response.body;
    List<dynamic> dynamicDrivers = jsonDecode(body);
    List<Driver> drivers = List.empty(growable: true);
    for (dynamic d in dynamicDrivers) {
      drivers.add(Driver.fromJson(d));
    }
    return drivers;
  }

  Future<Job> createJob(Job job) async {
    String path = '/dispatcher/createJob';
    Map m = Job.toJson(job);
    String json = jsonEncode(m);
    var response = await http.put(
      Uri.https(_host, path, {'userId': userId!.id}),
      body: json,
      headers: {'Content-Type': 'application/json', 'sessionId': sessionId!},
    );
    String body = response.body;
    Job jobCreated = Job.fromJson(jsonDecode(body));
    return jobCreated;
  }

  Future<Driver> getDriver(String id) async {
    var response = await http.get(Uri.https(_host, '/driver/getDriverInfo'));
    String body = response.body;
    return Driver.fromJson(jsonDecode(body));
  }

  Future<void> sendToken(String token) async {
    if (sessionId != null) {
      String path = '/user/updateToken';
      var response = await http.post(
          Uri.https(
              _host, path, {'sessionId': sessionId!, 'deviceInfo': token}),
          headers: {'sessionId': sessionId!});
      String body = response.body;
    }
  }

  Future<void> logout() async {
    Helpers.logout().then((value) async {
      if (value) {
        var response = await http.get(Uri.https(_host, '/user/logout', ),
            headers: {'sessionId': sessionId!});
        String body = response.body;
        ApiResponse apiResponse = ApiResponse.fromJson(jsonDecode(body));
        if (apiResponse.statusCode == 200 && apiResponse.message == 'SUCCESS') {
          userId = null;
          personalUserInfo = null;
          isInitialised = false;
          currentUserType = null;
          sessionId = null;
        }
      } else {
        throw Exception('Logout failed');
      }
    });
  }

  Future<Job> getJob(String jobId) async {
    var response = await http.get(
      Uri.https(_host, '/driver/getJobFromId',
          {'sessionId': sessionId!, 'jobId': jobId}),
      headers: {'sessionId': sessionId!},
    );
    String body = response.body;
    return Job.fromJson(jsonDecode(body));
  }

  Future<ApiResponse> changeJobAcceptanceStatus(
      String jobId, JobAcceptanceStatus acceptance) async {
    JobAcceptance jobAcceptance = JobAcceptance(jobId, userId!.id, acceptance);
    var response = await http.put(
      Uri.https(_host, '/driver/changeJobAcceptanceStatus'),
      body: jsonEncode(jobAcceptance, toEncodable: (obj) {
          return JobAcceptance.toJson(obj as JobAcceptance);
        }),
      headers: {'sessionId': sessionId!, 'content-type': 'application/json'},
    );
    String body = response.body;
    if(response.statusCode == 200) {
      return ApiResponse.fromJson(jsonDecode(body));
    }
    else {
      throw Exception('Failed to change job acceptance status');
    }
  }

  Future<JobComparison> getJobsForComparison(String jobId) async {
    var response = await http.get(
      Uri.https(_host, '/driver/getJobsForComparison', {'jobId': jobId}),
      headers: {'sessionId': sessionId!},
    );
    String body = response.body;
    return JobComparison.fromJson(jsonDecode(body));
  }

  Future<List<Job>> getInvitations() async {
    var response = await http.get(
      Uri.https(_host, '/driver/getInvitation', {'userId': userId!.id}),
      headers: {'sessionId': sessionId!},
    );

    String body = response.body;
    if(response.statusCode == 200) {
      return (jsonDecode(body) as List<dynamic>)
          .map((e) => Job.fromJson(e))
          .toList();
    }
    else {
      throw Exception('Failed to get invitations');
    }
  }
}
