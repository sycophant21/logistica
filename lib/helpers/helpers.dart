import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/models/co_ordinates.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/job_status.dart';
import 'package:test_123/models/pay_type.dart';
import 'package:test_123/models/payment_information.dart';
import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/session_id.dart';

class Helpers {
  static String apiKey = 'AIzaSyAazC9z06b5xIYHvXrbVHVJNOaKSmRme28';
  static BehaviorSubject<RemoteMessage> jobsStreamController = BehaviorSubject();
  static BehaviorSubject<RemoteMessage> networkStreamController = BehaviorSubject();

  static Widget getIcon(Job job) {
    JobStatus jobStatus = job.jobStatus;
    if (jobStatus == JobStatus.CREATED) {
      return const Icon(
        Icons.priority_high_outlined,
        color: Colors.amber,
      );
    } else if (jobStatus == JobStatus.ON_GOING) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator.adaptive(
          value: 0.5,
        ),
      );
    } else if (jobStatus == JobStatus.WAITING_FOR_DRIVER_CONFIRMATION) {
      return const Icon(
        Icons.schedule_outlined,
        color: Colors.black,
        size: 40,
      );
    } else if (jobStatus == JobStatus.DRIVERS_CONFIRMED) {
      return const Icon(
        Icons.done,
        color: Colors.amber,
      );
    } else if (jobStatus == JobStatus.FINISHED) {
      return const Icon(
        Icons.done,
        color: Colors.green,
      );
    } else {
      return Container();
    }
  }

  static bool compareDateTime(DateTime dateTime, DateTime other) {
    return dateTime.day == other.day &&
        dateTime.month == other.month &&
        dateTime.year == other.year;
  }

  static String getTimeString(DateTime dateTime) {
    TimeOfDay timeOfDay =
        TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
    return '${timeOfDay.hourOfPeriod.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')} ${timeOfDay.period.name.toUpperCase()}';
  }

  static String getDateTimeString(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day-$month-$year $hour:$minute';
  }

  static String getDateTimeIntlFormat(DateTime dateTime) {
    return DateFormat.MMM().add_d().add_y().add_jm().format(dateTime);
  }

  static String getDateString(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    return '$day-$month-$year';
  }

  static DateTime? getDateTimeFromString(String dateTime) {
    List<String> dateAndTime = dateTime.split(' ');
    if (dateAndTime.length == 2) {
      List<String> partsOfDate = dateAndTime.elementAt(0).split('-');
      if (partsOfDate.length == 3) {
        List<String> partsOfTime = dateAndTime.elementAt(1).split(':');
        if (partsOfTime.length == 2) {
          try {
            int year = int.parse(partsOfDate.elementAt(2));
            int month = int.parse(partsOfDate.elementAt(1));
            int day = int.parse(partsOfDate.elementAt(0));
            int hour = int.parse(partsOfTime.elementAt(0));
            int minute = int.parse(partsOfTime.elementAt(1));
            DateTime dateTime = DateTime(
              year,
              month,
              day,
              hour,
              minute,
              0,
              0,
              0,
            );
            if (dateTime.year == year &&
                dateTime.month == month &&
                dateTime.day == day &&
                dateTime.hour == hour &&
                dateTime.minute == minute) {
              return DateTime(
                year,
                month,
                day,
                hour,
                minute,
                0,
                0,
                0,
              );
            } else {
              return null;
            }
          } catch (e) {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  static String getInitials() {
    PersonalUserInfo personalUserInfo =
        APIHandler.getAPIHandler().personalUserInfo!;
    String name = personalUserInfo.name;
    String initials = '';
    List<String> nameParts = name.split(' ');
    if (nameParts.isNotEmpty) {
      initials += nameParts.elementAt(0)[0];
    }
    if (nameParts.length > 1) {
      initials += nameParts.elementAt(1)[0];
    }
    return initials;
  }

  static LatLng getLatLngFromCoordinates(CoOrdinates coOrdinates) {
    return LatLng(coOrdinates.latitude, coOrdinates.longitude);
  }

  static Future<SessionId?> getUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? value = sharedPreferences.getString('logistica_uid');
    if (value != null) {
      return SessionId(value);
    }
    return null;
  }

  static Future<bool> setUser(String sessionId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setString('logistica_uid', sessionId);
  }

  static Future<bool> logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.remove('logistica_uid');
  }


  static String getPaymentType(PayType payType) {
    String part1 = payType.name.substring(0, payType.name.indexOf('_'));
    String part2 = payType.name.substring(payType.name.indexOf('_') + 1);
    return '${part1.substring(0,1)}${part1.substring(1).toLowerCase()} ${part2.substring(0,1)}${part2.substring(1).toLowerCase()}';
  }

  static String getCamelCasing(String value) {
    return value
        .split(' ')
        .map((word) =>
    word.substring(0, 1).toUpperCase() +
        word.substring(1).toLowerCase())
        .join(' ');
  }
}
