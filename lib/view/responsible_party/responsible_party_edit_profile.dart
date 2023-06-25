import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_profile_controller.dart';

class ResponsiblePartyEditProfile extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String mobileNumber;

  const ResponsiblePartyEditProfile({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  State<ResponsiblePartyEditProfile> createState() =>
      _ResponsiblePartyEditProfile();
}

class _ResponsiblePartyEditProfile extends State<ResponsiblePartyEditProfile> {
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  DatabaseReference ref =
      FirebaseDatabase.instance.ref().child('responsibleParties');

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phonenumberController = TextEditingController();

  @override
  void initState() {
    _firstNameController.text = widget.firstName;
    _lastNameController.text = widget.lastName;
    _phonenumberController.text = widget.mobileNumber;
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phonenumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          mediaQuery.size.height * 0.1,
        ),
        child: AppBar(
          elevation: 0,
          title: Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height * 0.035),
            child: Text(
              'Edit Profile',
              style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontSize: mediaQuery.size.height * 0.04,
                color: const Color(0xFF221540),
              ),
            ),
          ),
          backgroundColor: Colors.white,
          leading: Padding(
            padding: EdgeInsets.fromLTRB(
              mediaQuery.size.width * 0.035,
              mediaQuery.size.height * 0.028,
              0,
              0,
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Color(0xFF221540),
              ),
            ),
          ),
        ),
      ),
      body: ChangeNotifierProvider(
          create: (_) => ResponsiblePartyProfileController(),
          child: Consumer<ResponsiblePartyProfileController>(
              builder: (context, provider, child) {
            return SafeArea(
              child: SingleChildScrollView(
                  child: StreamBuilder(
                stream: ref.child(userID!.toString()).onValue,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
                    // String email = map["email"];
                    // String fcmToken = map["fcmToken"];
                    // String firstName = map["firstName"];
                    // String lastName = map["lastName"];
                    // String mobileNumber = map["mobileNumber"];
                    String profilePicStatus = map["profilePicStatus"];
                    // String responsiblePartyID = map["responsiblePartyID"];
                    // String role = map["role"];

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.black54,
                                      blurRadius: 15.0,
                                      offset: Offset(0.0, 0.75))
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                            height: MediaQuery.of(context).size.height / 4,
                            width: MediaQuery.of(context).size.width / 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topCenter,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Center(
                                          child: Container(
                                            height: 120,
                                            width: 120,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  width: 2,
                                                )),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: provider.image == null
                                                    ? profilePicStatus == "None"
                                                        ? Image.asset(
                                                            'assets/images/no-image.png',
                                                            fit: BoxFit.cover,
                                                          )
                                                        : Image(
                                                            fit: BoxFit.cover,
                                                            image: NetworkImage(
                                                                profilePicStatus),
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
                                                              return const CircularProgressIndicator();
                                                            },
                                                            errorBuilder:
                                                                (context,
                                                                    object,
                                                                    stack) {
                                                              return const Icon(
                                                                Icons
                                                                    .error_outline,
                                                                color: Color(
                                                                    0xFF221540),
                                                              );
                                                            },
                                                          )
                                                    : Image.file(
                                                        fit: BoxFit.cover,
                                                        File(provider
                                                            .image!.path))),
                                          ),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: 130,
                                            width: 120,
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: InkWell(
                                                onTap: () {
                                                  provider.pickImage(context);
                                                },
                                                child: const CircleAvatar(
                                                  backgroundColor:
                                                      Color(0xFF221540),
                                                  radius: 20,
                                                  child: Icon(
                                                    Icons.add_a_photo,
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _firstNameController,
                                    cursorColor: const Color(0xFF221540),
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'First Name',
                                      labelStyle: const TextStyle(
                                        fontFamily: "Karla Regular",
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical:
                                            16, // Adjust the vertical padding here
                                        horizontal:
                                            24, // Adjust the horizontal padding here
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _lastNameController,
                                    cursorColor: const Color(0xFF221540),
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Last Name',
                                      labelStyle: const TextStyle(
                                        fontFamily: "Karla Regular",
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical:
                                            16, // Adjust the vertical padding here
                                        horizontal:
                                            24, // Adjust the horizontal padding here
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your last name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  TextFormField(
                                    controller: _phonenumberController,
                                    cursorColor: const Color(0xFF221540),
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Mobile Number',
                                      labelStyle: const TextStyle(
                                        fontFamily: "Karla Regular",
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical:
                                            16, // Adjust the vertical padding here
                                        horizontal:
                                            24, // Adjust the horizontal padding here
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your mobile number';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(164, 50),
                                backgroundColor: const Color(0xFF221540),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Adjust the radius as needed
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  String firstName = _firstNameController.text;
                                  String lastName = _lastNameController.text;
                                  String mobileNumber =
                                      _phonenumberController.text;

                                  await provider.updloadImage();
                                  await ref.child(userID!).update({
                                    'profilePicStatus': provider.imgURL,
                                    'firstName': firstName,
                                    'lastName': lastName,
                                    'mobileNumber': mobileNumber,
                                  });
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(
                                    context,
                                  );
                                }
                              },
                              child: const Text('Confirm')),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: const Size(164, 50),
                                backgroundColor: const Color(0xFF221540),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      30), // Adjust the radius as needed
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(
                                  context,
                                );
                              },
                              child: const Text('Cancel')),
                        ]);
                  } else {
                    return const Center(
                        child: Text('Something went wrong.',
                            style: TextStyle(fontFamily: "GothamRnd")));
                  }
                },
              )),
            );
          })),
    );
  }
}
