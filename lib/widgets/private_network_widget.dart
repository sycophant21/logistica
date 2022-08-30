import 'package:flutter/material.dart';
import 'package:test_123/models/driver.dart';
import 'package:test_123/models/personal_user_info.dart';

class PrivateNetwork extends StatefulWidget {
  final List<PersonalUserInfo> users;

  const PrivateNetwork({Key? key, required this.users}) : super(key: key);

  @override
  State<PrivateNetwork> createState() => _PrivateNetworkState();
}

class _PrivateNetworkState extends State<PrivateNetwork> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.users.map((e) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 6, 8, 6),
        child: InkWell(
          onTap: () {},
          child: Card(
            elevation: 2,
            child: ListTile(
              title: Text(
                e.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(47, 47, 47, 1)),
              ),
              subtitle: Text(e.userId.id),
            ),
          ),
        ),
      );
    }).toList());
  }
}
