import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/models/driver.dart';
import 'package:test_123/models/new_driver_info.dart';
import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/user_type.dart';
import 'package:test_123/models/vehicle_type.dart';

class DriverSignUpWidget extends StatefulWidget {
  const DriverSignUpWidget({Key? key}) : super(key: key);

  @override
  State<DriverSignUpWidget> createState() => _DriverSignUpWidgetState();
}

class _DriverSignUpWidgetState extends State<DriverSignUpWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _name = '';
  final TextEditingController _passwordController = TextEditingController();
  String _password = '';
  final TextEditingController _phoneNumberController = TextEditingController();
  String _phoneNumber = '';
  final TextEditingController _licenseNumberController =
      TextEditingController();
  String _licenseNumber = '';
  final TextEditingController _dispatcherCodeController =
      TextEditingController();
  String _dispatcherCode = '';
  final APIHandler apiHandler = APIHandler.getAPIHandler();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoNavigationBarBackButton(
          onPressed: () => Navigator.of(context).pop(false),
          color: CupertinoColors.systemBlue,
        ),
        trailing: TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Driver driver = Driver(
                  apiHandler.userId!,
                  PersonalUserInfo(_name, _phoneNumber, '', '', UserType.DRIVER,
                      apiHandler.userId!, true),
                  _licenseNumber,
                  VehicleType.A);
              NewDriverInfo newDriverInfo =
                  NewDriverInfo(driver, _dispatcherCode, _password);
              apiHandler.driverSignup(newDriverInfo).then(
                (value) {
                  if (value) {
                    Navigator.of(context).pop(value);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Signup failed',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
          child: const Text('Done'),
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            CupertinoFormSection(
              header: const Text(
                'Personal Details',
                style: TextStyle(fontSize: 16),
              ),
              footer: const Divider(),
              margin: const EdgeInsets.all(8),
              children: [
                CupertinoTextFormFieldRow(
                  padding: const EdgeInsets.all(12),
                  controller: _nameController,
                  placeholder: 'Name',
                  prefix: const Icon(
                    CupertinoIcons.person_solid,
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),
                CupertinoTextFormFieldRow(
                  padding: const EdgeInsets.all(12),
                  controller: _passwordController,
                  placeholder: 'Password',
                  prefix: const Icon(
                    CupertinoIcons.padlock_solid,
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ),
                CupertinoTextFormFieldRow(
                  padding: const EdgeInsets.all(12),
                  placeholder: 'Confirm Password',
                  prefix: const Icon(
                    CupertinoIcons.padlock_solid,
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                    }
                    return null;
                  },
                ),
                CupertinoTextFormFieldRow(
                  padding: const EdgeInsets.all(12),
                  controller: _phoneNumberController,
                  placeholder: 'Phone Number',
                  prefix: const Icon(
                    CupertinoIcons.phone_solid,
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  onSaved: (value) => _phoneNumber = value!,
                ),
              ],
            ),
            CupertinoFormSection(
              margin: const EdgeInsets.all(8),
              header: const Text(
                'Vehicle Details',
                style: TextStyle(fontSize: 16),
              ),
              footer: const Divider(),
              children: [
                CupertinoTextFormFieldRow(
                  padding: const EdgeInsets.all(12),
                  controller: _licenseNumberController,
                  placeholder: 'License Plate Number',
                  prefix: const Icon(
                    CupertinoIcons.phone_solid,
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your license number';
                    }
                    return null;
                  },
                  onSaved: (value) => _licenseNumber = value!,
                ),
              ],
            ),
            CupertinoFormSection(
              margin: const EdgeInsets.all(8),
              header: const Text(
                'Invitation Details',
                style: TextStyle(fontSize: 16),
              ),
              footer: const Divider(),
              children: [
                CupertinoTextFormFieldRow(
                  padding: const EdgeInsets.all(12),
                  controller: _dispatcherCodeController,
                  placeholder: 'Dispatcher Code',
                  prefix: const Icon(
                    CupertinoIcons.phone_solid,
                    color: CupertinoColors.lightBackgroundGray,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your dispatcher invite type';
                    }
                    return null;
                  },
                  onSaved: (value) => _dispatcherCode = value!,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
