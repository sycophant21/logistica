import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/job_acceptance_status.dart';

class InvitationScreen extends StatefulWidget {
  final List<Job> invitations;

  const InvitationScreen({required this.invitations, Key? key})
      : super(key: key);

  @override
  State<InvitationScreen> createState() => _InvitationScreenState();
}

class _InvitationScreenState extends State<InvitationScreen> {
  final APIHandler apiHandler = APIHandler.getAPIHandler();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.invitations.map((e) {
        return InkWell(
          child: Card(
            child: ListTile(
              trailing: SizedBox(
                width: 115,
                child: Row(
                  children: [
                    CupertinoButton(
                      child: const Icon(
                        CupertinoIcons.check_mark_circled,
                        color: CupertinoColors.activeGreen,
                      ),
                      onPressed: () {
                        apiHandler
                            .changeJobAcceptanceStatus(
                                e.jobId.jobId, JobAcceptanceStatus.ACCEPTED)
                            .then((value) {
                          if (value.statusCode == 200 &&
                              value.message == 'SUCCESS') {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Accepted Successfully')));
                            setState(() {
                              widget.invitations.remove(e);
                            });

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.message)));
                          }
                        });
                      },
                    ),
                    CupertinoButton(
                      child: const Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: CupertinoColors.destructiveRed,
                      ),
                      onPressed: () {
                        apiHandler
                            .changeJobAcceptanceStatus(
                                e.jobId.jobId, JobAcceptanceStatus.REJECTED)
                            .then((value) {
                          if (value.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Rejected Successfully')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(value.message)));
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              title: const Text(
                'Job Invitation',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(47, 47, 47, 1)),
              ),
              subtitle: Text(
                '${Helpers.getTimeString(e.jobInfo.scheduleInformation.startTime)} - ${Helpers.getTimeString(e.jobInfo.scheduleInformation.finishTime)}',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
