import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quality_control_tracker/view/responsible_party/responsible_party_profile_controller.dart';

class InspectorsEditProfile extends StatefulWidget {
  const InspectorsEditProfile({super.key});

  @override
  State<InspectorsEditProfile> createState() => _InspectorsEditProfile();
}

class _InspectorsEditProfile extends State<InspectorsEditProfile> {
  String? userID = FirebaseAuth.instance.currentUser?.uid;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('inspectors');

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    String email = map["email"];
                    String fcmInspectorToken = map["fcmInspectorToken"];
                    String firstName = map["firstName"];
                    String lastName = map["lastName"];
                    String mobileNumber = map["mobileNumber"];
                    String profilePicStatus = map["profilePicStatus"];
                    String inspectorID = map["inspectorID"];
                    String role = map["role"];

                    return Expanded(
                      child: Column(
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
                              width: MediaQuery.of(context).size.width / 0.5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Edit Profile",
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topCenter,
                                        clipBehavior: Clip.none,
                                        children: [
                                          Center(
                                            child: Container(
                                              height: 130,
                                              width: 130,
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
                                                      BorderRadius.circular(
                                                          100),
                                                  child: provider.image == null
                                                      ? profilePicStatus ==
                                                              "None"
                                                          ? Image.asset(
                                                              'assets/images/no-image.png',
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  profilePicStatus),
                                                              loadingBuilder:
                                                                  (context,
                                                                      child,
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
                                            child: Container(
                                              height: 125,
                                              width: 120,
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    provider.pickImage(context);
                                                  },
                                                  child: const CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xFF6096BA),
                                                    radius: 15,
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
                            ElevatedButton(
                                onPressed: () async {
                                  await provider.updloadImage();
                                  await ref.child(userID!).update({
                                    'profilePicStatus': provider.imgURL,
                                  });
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text('Confirm')),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                  );
                                },
                                child: const Text('Cancel')),
                          ]),
                    );
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
