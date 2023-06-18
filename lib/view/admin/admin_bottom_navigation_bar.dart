import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/admin/project_image_controller.dart';
import 'admin_home_page.dart';
import 'admin_list_page.dart';
import 'admin_inspector_creation_page.dart';
import 'dart:async';
import 'package:random_string/random_string.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({Key? key}) : super(key: key);

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {
  ShapeBorder? bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  int _selectedItemPosition = 0;
  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;
  final String projectID = randomAlphaNumeric(8);

  Color selectedColor = const Color(0xFF221540);
  Color unselectedColor = const Color(0xFF221540);

  StreamSubscription<DatabaseEvent>? nameSubscription;
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _projectLocationController =
      TextEditingController();
  final TextEditingController _inspectorController = TextEditingController();
  final TextEditingController _projectDeadlineController =
      TextEditingController();
  Map<String, dynamic>? nameSubscription1;

  var logger = Logger();

  final List<Widget> _pages = [
    const AdminHomePage(),
    const AdminListPage(),
  ];

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedItemPosition);
  }

  @override
  void dispose() {
    _projectNameController.dispose();
    _projectLocationController.dispose();
    _inspectorController.dispose();
    _pageController.dispose();
    _projectDeadlineController.dispose();

    super.dispose();
  }

  void itemSelectionChanged(String? inspectorName) {
    _inspectorController.text = inspectorName!;
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference ref = FirebaseDatabase.instance.ref().child('projects');
    DatabaseReference ref1 =
        FirebaseDatabase.instance.ref().child('inspectors');

    return StreamBuilder(
        stream: ref1.orderByChild('role').equalTo('Inspector').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            List<dynamic> dataList = [];
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;

            if (dataSnapshot.value != null) {
              dynamic values = dataSnapshot.value;
              values.forEach((key, data) {
                dataList.add(data);
              });
            }

            // DITO GIOVS
            return Scaffold(
              floatingActionButton: _selectedItemPosition == 0
                  ? FloatingActionButton(
                      onPressed: () async {
                        // ignore: use_build_context_synchronously
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            final screenHeight =
                                MediaQuery.of(context).size.height;
                            const desiredHeightFactor =
                                0.8; // Set the desired height factor (80%)
                            final desiredHeight =
                                screenHeight * desiredHeightFactor;

                            return ChangeNotifierProvider(
                                create: (_) => ProfileController(),
                                child: Consumer<ProfileController>(
                                    builder: (context, provider, child) {
                                  return SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: SafeArea(
                                      child: Container(
                                        height: desiredHeight,
                                        padding: const EdgeInsets.all(16),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              const Text(
                                                "Add project",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  provider.pickImage(
                                                      context, projectID);
                                                },
                                                child: Container(
                                                  height: 130,
                                                  width: 130,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.rectangle,
                                                      border: Border.all(
                                                        color: const Color
                                                                .fromARGB(
                                                            255, 35, 35, 35),
                                                        width: 2,
                                                      )),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadiusDirectional
                                                              .zero,
                                                      child: provider.image ==
                                                              null
                                                          ? const Icon(
                                                              Icons.add_a_photo,
                                                              size: 35,
                                                            )
                                                          
                                                          : Image.file(
                                                              fit: BoxFit.cover,
                                                              File(provider
                                                                      .image!
                                                                      .path)
                                                                  .absolute)),
                                                ),
                                              ),

                                              TextField(
                                                controller:
                                                    _projectNameController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Project Name',
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              TextField(
                                                controller:
                                                    _projectLocationController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: 'Project Location',
                                                ),
                                              ),
                                              const SizedBox(height: 16),

                                              DropdownSearch<String>(
                                                onChanged: itemSelectionChanged,
                                                dropdownDecoratorProps:
                                                    const DropDownDecoratorProps(
                                                        dropdownSearchDecoration:
                                                            InputDecoration(
                                                                hintText:
                                                                    "Inspector in-charge")),
                                                items: [
                                                  for (var item in dataList)
                                                    "${item["firstName"]} ${item["lastName"]}",
                                                ],
                                                popupProps: PopupProps.menu(
                                                  showSelectedItems: true,
                                                  searchFieldProps: TextFieldProps(
                                                      controller:
                                                          _inspectorController,
                                                      decoration:
                                                          const InputDecoration(
                                                              hintText:
                                                                  "Search Here")),
                                                  showSearchBox: true,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              // const TextField(
                                              //   decoration: InputDecoration(
                                              //     labelText: 'Project Deadline',
                                              //   ),
                                              // ),
                                              TextfieldDatePicker(
                                                cupertinoDatePickerBackgroundColor:
                                                    Colors.white,
                                                cupertinoDatePickerMaximumDate:
                                                    DateTime(2099),
                                                cupertinoDatePickerMaximumYear:
                                                    2099,
                                                cupertinoDatePickerMinimumYear:
                                                    1990,
                                                cupertinoDatePickerMinimumDate:
                                                    DateTime(1990),
                                                cupertinoDateInitialDateTime:
                                                    DateTime.now(),
                                                materialDatePickerFirstDate:
                                                    DateTime.now(),
                                                materialDatePickerInitialDate:
                                                    DateTime.now(),
                                                materialDatePickerLastDate:
                                                    DateTime(2099),
                                                preferredDateFormat: DateFormat(
                                                    'dd-MMMM-' 'yyyy'),
                                                textfieldDatePickerController:
                                                    _projectDeadlineController,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                ),
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                cursorColor: Colors.black,
                                                decoration: InputDecoration(
                                                  //errorText: errorTextValue,
                                                  helperStyle: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.grey),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderSide:
                                                              const BorderSide(
                                                                  color: Colors
                                                                      .white,
                                                                  width: 0),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2)),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(2),
                                                          borderSide:
                                                              const BorderSide(
                                                            width: 0,
                                                            color: Colors.white,
                                                          )),
                                                  hintText: 'Select Date',
                                                  hintStyle: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  filled: true,
                                                  fillColor: Colors.grey[300],
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ElevatedButton(
                                                onPressed: () async {
                                                  String projName =
                                                      _projectNameController
                                                          .text;
                                                  String projLocation =
                                                      _projectLocationController
                                                          .text;
                                                  String inspectorName =
                                                      _inspectorController.text;
                                                  String projDeadline =
                                                      _projectDeadlineController
                                                          .text;

                                                  String inspectorID = '';

                                                  for (var item in dataList) {
                                                    if (item['firstName'] ==
                                                            'Giovanni' &&
                                                        item['lastName'] ==
                                                            'De Vera') {
                                                      inspectorID =
                                                          item['inspectorID'];
                                                      break;
                                                    }
                                                  }

                                                  await ref
                                                      .child(projectID)
                                                      .update({
                                                    "HVAC": "-",
                                                    "HVACQuery": "-",
                                                    "carpenter": "-",
                                                    "carpenterQuery": "-",
                                                    "electrician": "-",
                                                    "electricianQuery": "-",
                                                    "inspector": inspectorName,
                                                    "inspectorQuery":
                                                        inspectorID,
                                                    "laborer": "-",
                                                    "laborerQuery": "-",
                                                    "landscaper": "-",
                                                    "landscaperQuery": "-",
                                                    "mason": "-",
                                                    "masonQuery": "-",
                                                    "owner": "-",
                                                    "ownerQuery": "-",
                                                    "painter": "-",
                                                    "painterQuery": "-",
                                                    "plumber": "-",
                                                    "plumberQuery": "-",
                                                    "projectDeadline":
                                                        projDeadline,
                                                    "projectID": projectID,
                                                    "projectImage":
                                                        provider.imgURL,
                                                    "projectLocation":
                                                        projLocation,
                                                    "projectManager": "-",
                                                    "projectManagerQuery": "-",
                                                    "projectName": projName,
                                                    "projectStatus": "ON-GOING",
                                                    "technician": "-",
                                                    "technicianQuery": "-",
                                                    "welder": "-",
                                                    "welderQuery": "-"
                                                  });

                                                  _projectNameController
                                                      .clear();
                                                  _projectLocationController
                                                      .clear();
                                                  _inspectorController.clear();
                                                  _projectDeadlineController
                                                      .clear();
                                                  // Perform the desired action when the button is pressed
                                                },
                                                child: const Text('Submit'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }));
                          },
                        );
                      },
                    )
                  : _selectedItemPosition == 1
                      ? FloatingActionButton(
                          onPressed: () {
                            Navigator.push<void>(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AdminInspectorCreationPage()));
                          },
                        )
                      : null,
              extendBodyBehindAppBar: true,
              resizeToAvoidBottomInset: true,
              extendBody: true,
              body: AnimatedContainer(
                duration: const Duration(seconds: 1),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: _pages,
                ),
              ),
              bottomNavigationBar: SnakeNavigationBar.color(
                behaviour: snakeBarStyle,
                snakeShape: snakeShape,
                shape: bottomBarShape,
                padding: padding,
                snakeViewColor: selectedColor,
                selectedItemColor:
                    snakeShape == SnakeShape.indicator ? selectedColor : null,
                unselectedItemColor: unselectedColor,
                currentIndex: _selectedItemPosition,
                onTap: (index) {
                  setState(() {
                    _selectedItemPosition = index;
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  });
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.list), label: 'Inspection'),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        });
  }
}
