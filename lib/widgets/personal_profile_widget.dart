import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/helpers.dart';

class PersonalProfileWidget extends StatelessWidget {
  final APIHandler apiHandler = APIHandler.getAPIHandler();

  PersonalProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: const [
              Text(
                'Account',
                style: TextStyle(
                    fontSize: 32,
                    color: Color.fromRGBO(27, 27, 27, 1),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
                    child: Text(
                      Helpers.getInitials(),
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      apiHandler.personalUserInfo!.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Edit',
                  style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(27, 27, 27, 1),
                      fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  primary: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
