import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/auth_service.dart';
import 'package:test_123/models/session.dart';
import 'package:test_123/models/user_type.dart';
import 'package:test_123/screens/sign_up_screen.dart';
import 'package:test_123/widgets/driver_signup_info_widget.dart';

class Login extends StatefulWidget {
  static const String route = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  final APIHandler apiHandler = APIHandler.getAPIHandler();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: Container(),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  'https://images.unsplash.com/photo-1584441405886-bc91be61e56a?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=430&q=80',
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  'Welcome to EazyTagz!',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, fontSize: 28),
                ),
              )
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 8, 48, 8),
                  child: TextFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      hintText: 'Email or Phone Number',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(27, 27, 27, 0.5),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field can\'t be empty';
                      } else if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                              .hasMatch(value) &&
                          !RegExp(r'^\([0-9]{3}\)[0-9]{3}-[0-9]{4}$')
                              .hasMatch(value)) {
                        return 'Not a valid input';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(48, 8, 48, 8),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(27, 27, 27, 0.5),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password can\'t be empty';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              apiHandler
                                  .login(usernameController.text,
                                      passwordController.text)
                                  .then((value) async {
                                if (Session.isEmpty(value)) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(value.message),
                                  ));
                                } else {
                                  if (value.personalUserInfo.userType ==
                                          UserType.DRIVER &&
                                      !value.personalUserInfo.initialised) {
                                    showCupertinoModalBottomSheet<bool>(
                                        context: context,
                                        builder: (context) {
                                          return const DriverSignUpWidget();
                                        }).then((value) {
                                      if (value!) {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                AuthService.route);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text('Login failed')));
                                      }
                                    });
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        AuthService.route);
                                  }
                                }
                                setState(() {
                                  _isLoading = true;
                                });
                              });
                            }
                          },
                    child: _isLoading
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('Login', style: TextStyle(fontSize: 20),),
                              CircularProgressIndicator.adaptive(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white),
                              ),
                            ],
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 20),
                          ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(27, 27, 27, 1),
                      fixedSize: const Size(296, 48),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(27, 27, 27, 0.75),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(SignUpScreen.route);
                  },
                  child: const Text(
                    'Register!',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

