import 'package:flutter/material.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/models/new_dispatcher_info.dart';

class UserPersonalDetailsInput extends StatefulWidget {
  final NewDispatcherInfo newDispatcherInfo;
  final StateSetter setState;

  const UserPersonalDetailsInput({required this.newDispatcherInfo, Key? key, required this.setState})
      : super(key: key);

  @override
  State<UserPersonalDetailsInput> createState() =>
      _UserPersonalDetailsInputState();
}

class _UserPersonalDetailsInputState extends State<UserPersonalDetailsInput> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController nameTextEditingController =
      TextEditingController();
  final TextEditingController emailTextEditingController =
      TextEditingController();
  final TextEditingController passwordTextEditingController =
      TextEditingController();
  final TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool doesPasswordMatch = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              controller: nameTextEditingController,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(
                    fontSize: 20, color: Color.fromRGBO(27, 27, 27, 1)),
                hintStyle:
                    TextStyle(color: Colors.black.withOpacity(0.35)),
                border: const OutlineInputBorder(),
                hintText: 'John Doe',
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) {
                widget.newDispatcherInfo.dispatcher.personalUserInfo.name = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              controller: emailTextEditingController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(
                    fontSize: 20, color: Color.fromRGBO(27, 27, 27, 1)),
                hintText: 'john.doe123@email.com',
                hintStyle:
                    TextStyle(color: Colors.black.withOpacity(0.35)),
                border: const OutlineInputBorder(),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
              onSaved: (value) {
                widget.newDispatcherInfo.dispatcher.personalUserInfo.userId.id = value!;
                widget.newDispatcherInfo.dispatcher.userId.id = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              controller: passwordTextEditingController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                hintStyle:
                    TextStyle(color: Colors.black.withOpacity(0.35)),
                border: const OutlineInputBorder(),
                labelText: 'Password',
                labelStyle: const TextStyle(
                    fontSize: 20, color: Color.fromRGBO(27, 27, 27, 1)),
                hintText: '********',
                suffixIcon: isPasswordVisible
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = false;
                          });
                        },
                        icon: const Icon(
                          Icons.visibility_off_outlined,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = true;
                          });
                        },
                        icon: const Icon(
                          Icons.visibility_outlined,
                        ),
                      ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                widget.newDispatcherInfo.password = value!;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: TextFormField(
              controller: confirmPasswordTextEditingController,
              obscureText: !isConfirmPasswordVisible,
              decoration: InputDecoration(
                hintStyle:
                    TextStyle(color: Colors.black.withOpacity(0.35)),
                border: const OutlineInputBorder(),
                focusColor:
                    doesPasswordMatch ? Colors.blue : Colors.green,
                labelText: 'Confirm Password',
                labelStyle: const TextStyle(
                    fontSize: 20, color: Color.fromRGBO(27, 27, 27, 1)),
                hintText: '********',
                suffixIcon: isConfirmPasswordVisible
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible = false;
                          });
                        },
                        icon: const Icon(
                          Icons.visibility_off_outlined,
                        ),
                      )
                    : IconButton(
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible = true;
                          });
                        },
                        icon: const Icon(
                          Icons.visibility_outlined,
                        ),
                      ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                helperText: doesPasswordMatch ? 'Password Confirmed' : '',
                helperStyle: const TextStyle(color: Colors.green),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value != passwordTextEditingController.text) {
                  return 'Password does not match';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
