import 'package:test_123/models/dispatcher.dart';

class NewDispatcherInfo {
  Dispatcher dispatcher;
  String password;

  NewDispatcherInfo({required this.dispatcher, required this.password});


  static Map toJson(NewDispatcherInfo newDispatcherInfo) {
    return {
      'dispatcher': Dispatcher.toJson(newDispatcherInfo.dispatcher),
      'password': newDispatcherInfo.password,
    };
  }

  static NewDispatcherInfo empty() {
    return NewDispatcherInfo(
      dispatcher: Dispatcher.empty(),
      password: '',
    );
  }
}