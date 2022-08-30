import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_123/helpers/api_handler.dart';
import 'package:test_123/helpers/helpers.dart';
import 'package:test_123/helpers/job_mode.dart';
import 'package:test_123/helpers/status.dart';
import 'package:test_123/models/driver.dart';
import 'package:test_123/models/job.dart';
import 'package:test_123/models/personal_user_info.dart';
import 'package:test_123/models/user_type.dart';
import 'package:test_123/screens/goods_and_company_info_input_for_create_job_screen.dart';
import 'package:test_123/screens/invitations_screen.dart';
import 'package:test_123/screens/job_search_screen.dart';
import 'package:test_123/screens/settings_screen.dart';
import 'package:test_123/widgets/current_jobs_widget.dart';
import 'package:test_123/widgets/private_network_widget.dart';

import '../helpers/month.dart';

class Home extends StatefulWidget {
  static const String route = '/home';

  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Job> currentJobs = List.empty(growable: true);
  List<Job> invitations = List.empty(growable: true);
  List<PersonalUserInfo> personalUserInfos = List.empty(growable: true);
  List<Driver> users = List.empty(growable: true);
  DateTime dateTime = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int selectedIndex = 2;
  final APIHandler apiHandler = APIHandler.getAPIHandler();
  bool isDriver = true;
  int counter = 4;
  bool isJobsRequested = false;
  bool isPrivateNetworkRequested = false;
  String userConnectionCode = '';
  bool isCodeCorrect = true;
  final GlobalKey<FormState> _key = GlobalKey();
  DateTime selectedDate = DateTime.now();
  bool jobReceived = false;
  bool networkRequestReceived = false;

  bool invitationsReceived = false;
  bool isInvitationsRequested = false;
  int invitationsCounter = 0;

  @override
  void initState() {
    super.initState();
    getJobs();
    getPrivateNetwork();
    getInvitations();
    Helpers.jobsStreamController.stream.listen((event) {
      setState(() {
        jobReceived = true;
        invitationsCounter++;
      });
    });
    Helpers.networkStreamController.stream.listen((event) {
      setState(() {
        networkRequestReceived = true;
        invitationsCounter++;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    Helpers.jobsStreamController.close();
    Helpers.jobsStreamController = BehaviorSubject();
    Helpers.networkStreamController.close();
    Helpers.networkStreamController = BehaviorSubject();
  }

  Future<void> getInvitations() async {
    await apiHandler.getInvitations().then((value) {
      setState(() {
        invitations.clear();
        invitations.addAll(value);
        invitationsCounter = invitations.length;
        invitations.sort((a, b) {
          return b.jobInfo.scheduleInformation.startTime
              .compareTo(a.jobInfo.scheduleInformation.startTime);
        });
        isInvitationsRequested = false;
        invitationsReceived = false;
      });
    }, onError: (error) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to fetch data, try again later.'),
          ),
        );
        isInvitationsRequested = false;
      });
    });
  }

  Future<void> getJobs() async {
    setState(() {
      currentJobs.clear();
    });
    await apiHandler.getJobs(dateTime).then((value) {
      setState(() {
        currentJobs.addAll(value);
        currentJobs.sort((a, b) {
          return a.jobInfo.scheduleInformation.startTime
              .compareTo(b.jobInfo.scheduleInformation.startTime);
        });
        isJobsRequested = false;
        jobReceived = false;
      });
    }, onError: (error) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to fetch data, try again later.'),
            duration: Duration(seconds: 1),
          ),
        );
        isJobsRequested = false;
      });
    });
  }

  Future<void> getPrivateNetwork() async {
    await apiHandler.getPrivateNetwork().then((value) {
      setState(() {
        personalUserInfos.clear();
        personalUserInfos.addAll(value);
        isPrivateNetworkRequested = false;
        networkRequestReceived = false;
      });
    }, onError: (error) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to fetch data, try again later.'),
          ),
        );
        isPrivateNetworkRequested = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          selectedIndex == 0
              ? 'Invitations'
              : selectedIndex == 1
                  ? 'Network'
                  : selectedIndex == 2
                      ? 'Jobs'
                      : selectedIndex == 3
                          ? 'Jobs Search'
                          : selectedIndex == 4
                              ? 'Settings'
                              : '',
          style: const TextStyle(fontSize: 32),
        ),
        leading: Container(),
        leadingWidth: 0,
        centerTitle: false,
        actions: [
          selectedIndex == 2
              ? apiHandler.currentUserType == UserType.DISPATCHER
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(CupertinoPageRoute(builder: (ctx) {
                          return GoodsAndCompanyInfoInputForCreateJobScreen(job: Job.empty(),jobMode: JobMode.CREATE,);
                        }));
                      },
                      icon: const Icon(CupertinoIcons.plus),
                    )
                  : Container()
              : selectedIndex == 1
                  ? IconButton(
                      onPressed: () {
                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (ctx) {
                            return CupertinoAlertDialog(
                              title: const Text(
                                "Add Driver",
                                style: TextStyle(fontSize: 18),
                              ),
                              content: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Form(
                                  key: _key,
                                  child: Column(
                                    children: [
                                      Text(
                                          'Enter ${apiHandler.currentUserType == UserType.DRIVER ? Helpers.getCamelCasing(UserType.DISPATCHER.name) : apiHandler.currentUserType == UserType.DISPATCHER ? Helpers.getCamelCasing(UserType.DRIVER.name) : ''}\'s code'),
                                      CupertinoTextFormFieldRow(
                                        prefix: isCodeCorrect
                                            ? null
                                            : const Icon(
                                                CupertinoIcons
                                                    .exclamationmark_circle,
                                                color: Colors.red,
                                              ),
                                        placeholder:
                                            apiHandler.currentUserType ==
                                                    UserType.DRIVER
                                                ? 'Dispatcher Connection Code'
                                                : 'Driver Email Id',
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              color:
                                                  Colors.grey.withOpacity(0.75),
                                            ),
                                          ),
                                        ),
                                        validator: apiHandler.currentUserType ==
                                                UserType.DRIVER
                                            ? (value) {
                                                try {
                                                  if (RegExp(
                                                          r'^[a-zA-Z0-9]{6}$')
                                                      .hasMatch(value!)) {
                                                    return null;
                                                  } else {
                                                    return 'Invalid code';
                                                  }
                                                } catch (e) {
                                                  return 'Invalid code';
                                                }
                                              }
                                            : (value) {
                                                try {
                                                  return null;
                                                } catch (e) {
                                                  return 'Enter a valid email Id';
                                                }
                                              },
                                        onSaved: (value) {
                                          userConnectionCode = value!;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                CupertinoDialogAction(
                                    isDefaultAction: true,
                                    child: const Text("Add"),
                                    onPressed: () async {
                                      if (_key.currentState!.validate()) {
                                        _key.currentState!.save();
                                        if (apiHandler.currentUserType ==
                                            UserType.DISPATCHER) {
                                          if ((await apiHandler.addDriver(
                                                      userConnectionCode))
                                                  .status ==
                                              Status.PASSED) {
                                            Navigator.pop(context);
                                            showCupertinoDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return CupertinoAlertDialog(
                                                    title:
                                                        const Text('Success'),
                                                    content: const Text(
                                                        'Driver added successfully'),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        isDefaultAction: true,
                                                        child: const Text('Ok'),
                                                        onPressed: () {
                                                          Navigator.pop(ctx);
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Unable to add driver. Check email and try again.'),
                                              ),
                                            );
                                          }
                                        } else {
                                          if (await apiHandler.addDispatcher(
                                              userConnectionCode)) {
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Unable to add dispatcher. Check code and try again.'),
                                              ),
                                            );
                                          }
                                        }
                                        getPrivateNetwork();
                                      }
                                    }),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    setState(() {
                                      isCodeCorrect = true;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        ).then((value) {
                          setState(() {
                            isCodeCorrect = true;
                          });
                        });
                      },
                      icon: const Icon(
                        CupertinoIcons.person_add,
                      ),
                    )
                  : Container(),
        ],
        bottom: selectedIndex == 2
            ? PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: InkWell(
                  onTap: () {
                    isJobsRequested ? null : showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext builder) {
                          return Container(
                            padding: EdgeInsets.zero,
                            margin: EdgeInsets.zero,
                            height:
                                MediaQuery.of(context).copyWith().size.height *
                                    0.35,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CupertinoButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        alignment: Alignment.topRight,
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(27, 27, 27, 1),
                                            fontSize: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoButton(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        alignment: Alignment.topRight,
                                        child: const Text(
                                          'Done',
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(27, 27, 27, 1),
                                            fontSize: 18,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            dateTime = selectedDate;
                                            isJobsRequested = true;
                                            getJobs();
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: CupertinoDatePicker(
                                    mode: CupertinoDatePickerMode.date,
                                    onDateTimeChanged: (value) {
                                      selectedDate = value;
                                    },
                                    dateOrder: DatePickerDateOrder.mdy,
                                    initialDateTime: DateTime.now(),
                                    maximumDate: DateTime.now()
                                        .add(const Duration(days: 30)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: AppBar(
                    title: Text(
                      '${dateTime.day} ${Month.values.elementAt(dateTime.month - 1).name}, ${dateTime.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    centerTitle: true,
                    backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
                    leading: IconButton(
                      icon: const Icon(
                        Icons.chevron_left,
                      ),
                      onPressed: isJobsRequested
                          ? null
                          : () {
                              setState(() {
                                dateTime =
                                    dateTime.subtract(const Duration(days: 1));
                                isJobsRequested = true;
                                getJobs();
                              });
                            },
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(
                          Icons.chevron_right,
                        ),
                        onPressed: isJobsRequested
                            ? null
                            : () {
                                setState(() {
                                  dateTime =
                                      dateTime.add(const Duration(days: 1));
                                  isJobsRequested = true;
                                  getJobs();
                                });
                              },
                      )
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              return selectedIndex == 2
                  ? await getJobs()
                  : selectedIndex == 1
                      ? await getPrivateNetwork()
                      : selectedIndex == 0
                          ? await getInvitations()
                          : Future.value(null);
            },
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Column(
                  children: [
                    //Visibility(child: CupertinoActivityIndicator(radius: 14,),visible: true,),
                    Visibility(
                      child: const Text(
                        'New information received, refresh to view',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      visible: selectedIndex == 2
                          ? jobReceived
                          : selectedIndex == 1
                              ? networkRequestReceived
                              : false,
                    ),
                    selectedIndex == 0
                        ? InvitationScreen(invitations: invitations)
                        : selectedIndex == 2
                            ? currentJobs.isNotEmpty
                                ? CurrentJobs(currentJobs: currentJobs)
                                : const Center(
                                    child: Text('Nothing to see here yet.'),
                                  )
                            : selectedIndex == 1
                                ? personalUserInfos.isNotEmpty
                                    ? PrivateNetwork(users: personalUserInfos)
                                    : const Center(
                                        child: Text('Nothing to see here yet.'),
                                      )
                                : selectedIndex == 3
                                    ? const JobSearchScreen()
                                    : const SettingsScreen(),
                  ],
                );
              },
              childCount: 1,
            ),
          )
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 60,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        activeColor: Colors.white.withOpacity(0.75),
        backgroundColor: const Color.fromRGBO(27, 27, 27, 1),
        items: [
          BottomNavigationBarItem(
            label: 'Invitations',
            icon: Badge(
              showBadge: invitationsCounter > 0,
              badgeContent: Text(
                '$invitationsCounter',
                style: const TextStyle(color: Colors.white),
              ),
              child: const Icon(
                CupertinoIcons.bag,
                size: 24,
              ),
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Network',
            icon: Icon(
              CupertinoIcons.group,
              size: 38,
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Jobs',
            icon: Icon(
              CupertinoIcons.briefcase,
              size: 24,
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(
              CupertinoIcons.search,
              size: 24,
            ),
          ),
          const BottomNavigationBarItem(
            label: 'Settings',
            icon: Icon(
              CupertinoIcons.settings,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

}
