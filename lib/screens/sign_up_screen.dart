import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/models/new_dispatcher_info.dart';
import 'package:test_123/screens/dispatcher_info_screen.dart';
import 'package:test_123/widgets/user_personal_details_input.dart';

import '../helpers/auth_service.dart';
import '../models/dispatcher.dart';

class SignUpScreen extends StatefulWidget {
  static const String route = '/signUp';

  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  int activeStep = 0;
  final APIHandler apiHandler = APIHandler.getAPIHandler();
  final NewDispatcherInfo newDispatcherInfo = NewDispatcherInfo.empty();
  final GlobalKey<FormState> _personalInfoFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _companyInfoFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            setState(() {
              if (activeStep == 1) {
                activeStep--;
              } else {
                Navigator.of(context).pop();
              }
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          Visibility(
            child: TextButton(
              onPressed: () {
                setState(() {
                  if (_personalInfoFormKey.currentState!.validate()) {
                    setState(() {
                      _personalInfoFormKey.currentState!.save();
                      activeStep++;
                    });
                  }
                });
              },
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            visible: activeStep == 0,
          ),
          Visibility(
            child: TextButton(
              onPressed: () async {
                if (_companyInfoFormKey.currentState!.validate()) {
                  setState(() {
                    _companyInfoFormKey.currentState!.save();
                    newDispatcherInfo.dispatcher.personalUserInfo.phoneNumber =
                        '789-192-9546';
                  });
                  await apiHandler
                      .dispatcherSignup(newDispatcherInfo)
                      .then((value) {
                    setState(() {
                      if (!Dispatcher.isEmpty(value)) {
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                        Navigator.of(context)
                            .pushReplacementNamed(AuthService.route);
                      }
                    });
                  });
                }
              },
              child: const Text(
                'Done',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            visible: activeStep == 1,
          ),
        ],
        bottom: AppBar(
          backgroundColor: Colors.white,
          leading: const SizedBox(),
          title: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Text(
                  activeStep == 0
                      ? 'User Information'
                      : activeStep == 1
                          ? 'Company Information'
                          : '',
                  style: const TextStyle(
                    color: Color.fromRGBO(
                      27,
                      27,
                      27,
                      1,
                    ),
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  activeStep == 0
                      ? 'Step 1 of 2'
                      : activeStep == 1
                          ? 'Step 2 of 2'
                          : '',
                  style: const TextStyle(
                    color: Color.fromRGBO(
                      27,
                      27,
                      27,
                      0.6,
                    ),
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: activeStep == 0
          ? Form(
              key: _personalInfoFormKey,
              child: UserPersonalDetailsInput(
                newDispatcherInfo: newDispatcherInfo,
                setState: setState,
              ),
            )
          : activeStep == 1
              ? Form(
                  key: _companyInfoFormKey,
                  child: DispatcherInfoScreen(
                    newDispatcherInfo: newDispatcherInfo,
                  ),
                )
              : Container(),
    );
  }
}
