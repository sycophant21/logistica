import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/models/user_type.dart';
import 'package:test_123/widgets/personal_profile_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final APIHandler apiHandler = APIHandler.getAPIHandler();
  bool isDriver = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isDriver = apiHandler.currentUserType == UserType.DRIVER;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24),
      child: Column(
        children: [
          PersonalProfileWidget(),
          CupertinoFormRow(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: CupertinoSwitch(
              activeColor: const Color.fromRGBO(27, 27, 27, 1),
              trackColor: const Color.fromRGBO(27, 27, 27, 1),
              value: isDriver,
              onChanged: apiHandler.personalUserInfo!.userType == UserType.BOTH
                  ? (value) {
                      setState(() {
                        isDriver = value;
                        apiHandler.currentUserType =
                            isDriver ? UserType.DRIVER : UserType.DISPATCHER;
                      });
                    }
                  : null,
            ),
            prefix: Text(
              isDriver ? 'Driver' : 'Dispatcher',
              style: const TextStyle(
                  fontSize: 22,
                  color: Color.fromRGBO(27, 27, 27, 1),
                  fontWeight: FontWeight.bold),
            ),
          ),
          CupertinoButton(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                //Icon(CupertinoIcons.square_arrow_right),
                Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            onPressed: () {
              apiHandler.logout().then((value) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', (Route<dynamic> route) => false);
              });

            },
          ),
        ],
      ),
    );
  }
}
