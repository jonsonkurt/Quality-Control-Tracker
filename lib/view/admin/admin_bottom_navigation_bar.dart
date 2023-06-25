import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/admin/project_image_controller.dart';
import 'admin_home_page.dart';
import 'admin_list_page.dart';
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
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  Map<String, dynamic>? nameSubscription1;
  bool noticeState = false;

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
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
            return Scaffold(
              floatingActionButton: _selectedItemPosition == 0
                  ? FloatingActionButton(
                      backgroundColor: const Color(0xFF221540),
                      child: const Icon(Icons.add),
                      onPressed: () async {
                        final screenHeight = MediaQuery.of(context).size.height;
                        const desiredHeightFactor =
                            0.8; // Set the desired height factor (80%)
                        final desiredHeight =
                            screenHeight * desiredHeightFactor;
                        showModalBottomSheet<dynamic>(
                          backgroundColor: const Color(0xffDCE4E9),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) => Padding(
                            padding: EdgeInsets.only(
                                top: 20,
                                right: 20,
                                left: 20,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Form(
                              key: formKey,
                              child: ChangeNotifierProvider(
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
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.02,
                                                    ),
                                                    Text(
                                                      "Add project",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Rubik Bold',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                        color: const Color(
                                                            0xff221540),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
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
                                                        shape:
                                                            BoxShape.rectangle,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                          color: const Color(
                                                              0xff221540),
                                                          width: 2,
                                                        )),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      child: provider.image ==
                                                              null
                                                          ? const Icon(
                                                              Icons.add_circle,
                                                              size: 35,
                                                              color: Color(
                                                                  0xff221540),
                                                            )
                                                          : Image.file(
                                                              fit: BoxFit.cover,
                                                              File(provider
                                                                      .image!
                                                                      .path)
                                                                  .absolute),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: noticeState == false
                                                      ? Text(
                                                          "Please attach an image.",
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Karla Regular',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                        )
                                                      : SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.03,
                                                ),
                                                TextFormField(
                                                  cursorColor:
                                                      const Color(0xFF221540),
                                                  controller:
                                                      _projectNameController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            12, 4, 4, 0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        borderSide:
                                                            BorderSide.none),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText: 'Project Name',
                                                    labelStyle: TextStyle(
                                                      fontFamily:
                                                          'Karla Regular',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter a project name';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                TextFormField(
                                                  cursorColor:
                                                      const Color(0xFF221540),
                                                  controller:
                                                      _projectLocationController,
                                                  decoration: InputDecoration(
                                                    contentPadding:
                                                        const EdgeInsets
                                                                .fromLTRB(
                                                            12, 4, 4, 0),
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        borderSide:
                                                            BorderSide.none),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                    filled: true,
                                                    fillColor: Colors.white,
                                                    hintText:
                                                        'Project Location',
                                                    labelStyle: TextStyle(
                                                      fontFamily:
                                                          'Karla Regular',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return 'Please enter a project location';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                DropdownSearch<String>(
                                                  onChanged:
                                                      itemSelectionChanged,
                                                  dropdownDecoratorProps:
                                                      DropDownDecoratorProps(
                                                    dropdownSearchDecoration:
                                                        InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              12, 4, 4, 0),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText:
                                                          "Inspector in-charge",
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Karla Regular',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                    ),
                                                  ),
                                                  items: [
                                                    for (var item in dataList)
                                                      "${item["firstName"]} ${item["lastName"]}",
                                                  ],
                                                  popupProps: PopupProps.menu(
                                                    showSelectedItems: true,
                                                    searchFieldProps:
                                                        TextFieldProps(
                                                      cursorColor: const Color(
                                                          0xFF221540),
                                                      controller:
                                                          _inspectorController,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        hintText:
                                                            "Search Inspector",
                                                        labelStyle: TextStyle(
                                                          fontFamily:
                                                              'Karla Regular',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                      ),
                                                    ),
                                                    showSearchBox: true,
                                                  ),
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please select an inspector';
                                                    }
                                                    return null; // Return null if the input is valid
                                                  },
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.01),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .095,
                                                  child: TextfieldDatePicker(
                                                    textfieldDatePickerWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                    textAlignVertical:
                                                        TextAlignVertical
                                                            .bottom,
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
                                                    preferredDateFormat:
                                                        DateFormat(
                                                      'dd-MMMM-' 'yyyy',
                                                    ),
                                                    textfieldDatePickerController:
                                                        _projectDeadlineController,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          'Karla Regular',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                      color: const Color(
                                                          0xff221540),
                                                    ),
                                                    textCapitalization:
                                                        TextCapitalization
                                                            .sentences,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .fromLTRB(
                                                              12, 4, 4, 18),
                                                      border:
                                                          OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText: 'Select Date',
                                                      labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Karla Regular',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter a deadline';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.012),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ),
                                                    backgroundColor:
                                                        const Color(0xFF221540),
                                                  ),
                                                  onPressed: () async {
                                                    // ignore: use_build_context_synchronously
                                                    if (formKey.currentState!
                                                        .validate()) {
                                                      await provider
                                                          .updloadImage(
                                                              projectID);
                                                      String projName =
                                                          _projectNameController
                                                              .text;
                                                      String projLocation =
                                                          _projectLocationController
                                                              .text;
                                                      String inspectorName =
                                                          _inspectorController
                                                              .text;
                                                      String projDeadline =
                                                          _projectDeadlineController
                                                              .text;

                                                      String inspectorID = '';

                                                      for (var item
                                                          in dataList) {
                                                        String fullName =
                                                            "${item['firstName']} ${item['lastName']}";
                                                        if (fullName ==
                                                            inspectorName) {
                                                          inspectorID = item[
                                                              'inspectorID'];
                                                          break;
                                                        }
                                                      }
                                                      if (provider.imgURL !=
                                                          "") {
                                                        await ref
                                                            .child(projectID)
                                                            .update({
                                                          "projectImage":
                                                              provider.imgURL,
                                                        });
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
                                                        "inspector":
                                                            inspectorName,
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
                                                        "projectLocation":
                                                            projLocation,
                                                        "projectManager": "-",
                                                        "projectManagerQuery":
                                                            "-",
                                                        "projectName": projName,
                                                        "projectStatus":
                                                            "ON-GOING",
                                                        "technician": "-",
                                                        "technicianQuery": "-",
                                                        "welder": "-",
                                                        "welderQuery": "-"
                                                      });

                                                      _projectNameController
                                                          .clear();
                                                      _projectLocationController
                                                          .clear();
                                                      _inspectorController
                                                          .clear();
                                                      _projectDeadlineController
                                                          .clear();

                                                      // Perform the desired action when the button is pressed
                                                      // ignore: use_build_context_synchronously
                                                      Navigator.pop(context);
                                                    } else {
                                                      noticeState = true;
                                                    }
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.017),
                                                    child: Text(
                                                      'Submit',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Rubik Regular',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : _selectedItemPosition == 1
                      ? FloatingActionButton(
                          backgroundColor: const Color(0xFF221540),
                          child: const Icon(Icons.add),
                          onPressed: () {
                            final screenHeight =
                                MediaQuery.of(context).size.height;
                            const desiredHeightFactor =
                                0.8; // Set the desired height factor (80%)
                            final desiredHeight =
                                screenHeight * desiredHeightFactor;

                            showModalBottomSheet<dynamic>(
                              backgroundColor: const Color(0xffDCE4E9),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              )),
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    top: 20,
                                    right: 20,
                                    left: 20,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: Form(
                                  key: formKey,
                                  child: ChangeNotifierProvider(
                                    create: (_) => ProfileController(),
                                    child: Consumer<ProfileController>(
                                      builder: (context, provider, child) {
                                        return SingleChildScrollView(
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: SafeArea(
                                              child: Container(
                                                height: desiredHeight,
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.01,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.02,
                                                          ),
                                                          Text(
                                                            "Add Inspector",
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Rubik Bold',
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                              color: const Color(
                                                                  0xff221540),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.03,
                                                      ),
                                                      TextFormField(
                                                        cursorColor:
                                                            const Color(
                                                                0xFF221540),
                                                        controller:
                                                            firstNameController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12, 4, 4, 0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText:
                                                              'First Name',
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Karla Regular',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter first name';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      TextFormField(
                                                        cursorColor:
                                                            const Color(
                                                                0xFF221540),
                                                        controller:
                                                            lastNameController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12, 4, 4, 0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: 'Last Name',
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Karla Regular',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter last name';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      TextFormField(
                                                        cursorColor:
                                                            const Color(
                                                                0xFF221540),
                                                        controller:
                                                            emailController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12, 4, 4, 0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: 'Email',
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Karla Regular',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please enter a valid email';
                                                          } else if (!RegExp(
                                                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                                              .hasMatch(
                                                                  value)) {
                                                            return 'Please enter a valid email';
                                                          }
                                                          return null; // Return null if there is no error
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .emailAddress,
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                      TextFormField(
                                                        cursorColor:
                                                            const Color(
                                                                0xFF221540),
                                                        controller:
                                                            passwordController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12, 4, 4, 0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText: 'Password',
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Karla Regular',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter a password';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      TextFormField(
                                                        cursorColor:
                                                            const Color(
                                                                0xFF221540),
                                                        controller:
                                                            confirmPasswordController,
                                                        decoration:
                                                            InputDecoration(
                                                          contentPadding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  12, 4, 4, 0),
                                                          border: OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          hintText:
                                                              'Confirm Password',
                                                          labelStyle: TextStyle(
                                                            fontFamily:
                                                                'Karla Regular',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'Please confirm your password';
                                                          }
                                                          if (value !=
                                                              passwordController
                                                                  .text) {
                                                            return 'Passwords do not match';
                                                          }
                                                          return null; // Return null if there is no error
                                                        },
                                                      ),
                                                      SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.04),
                                                      ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF221540),
                                                        ),
                                                        onPressed: () async {
                                                          if (formKey
                                                              .currentState!
                                                              .validate()) {
                                                            final firstName =
                                                                firstNameController
                                                                    .text;
                                                            final lastName =
                                                                lastNameController
                                                                    .text;
                                                            final email =
                                                                emailController
                                                                    .text;
                                                            final password =
                                                                passwordController
                                                                    .text;
                                                            try {
                                                              // ignore: unused_local_variable
                                                              final credential =
                                                                  await FirebaseAuth
                                                                      .instance
                                                                      .createUserWithEmailAndPassword(
                                                                email: email,
                                                                password:
                                                                    password,
                                                              );

                                                              String? userID =
                                                                  FirebaseAuth
                                                                      .instance
                                                                      .currentUser
                                                                      ?.uid;

                                                              await FirebaseDatabase
                                                                  .instance
                                                                  .ref(
                                                                      "inspectors/$userID")
                                                                  .set({
                                                                "firstName":
                                                                    firstName,
                                                                "lastName":
                                                                    lastName,
                                                                "role":
                                                                    "Inspector",
                                                                "email": email,
                                                                "mobileNumber":
                                                                    "-",
                                                                "profilePicStatus":
                                                                    "None",
                                                                "inspectorID":
                                                                    userID,
                                                                "fcmInspectorToken":
                                                                    "-",
                                                              });
                                                              // Reset form fields after successful sign up
                                                              firstNameController
                                                                  .clear();
                                                              lastNameController
                                                                  .clear();
                                                              emailController
                                                                  .clear();
                                                              passwordController
                                                                  .clear();
                                                              confirmPasswordController
                                                                  .clear();
                                                              // ignore: use_build_context_synchronously
                                                              Navigator.pop(
                                                                  context);
                                                            } on FirebaseAuthException catch (e) {
                                                              if (e.code ==
                                                                  'weak-password') {
                                                                // ignore: use_build_context_synchronously
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'The password provided is too weak.')),
                                                                );
                                                              } else if (e
                                                                      .code ==
                                                                  'email-already-in-use') {
                                                                // ignore: use_build_context_synchronously
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                  const SnackBar(
                                                                      content: Text(
                                                                          'The account already exists for that email.')),
                                                                );
                                                              }
                                                            } catch (e) {
                                                              // ignore: use_build_context_synchronously
                                                              ScaffoldMessenger
                                                                      .of(context)
                                                                  .showSnackBar(
                                                                const SnackBar(
                                                                    content: Text(
                                                                        'Error.')),
                                                              );
                                                            }
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .all(MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.017),
                                                          child: Text(
                                                            'Submit',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'Rubik Regular',
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.02),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
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
                elevation: 10.0,
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
