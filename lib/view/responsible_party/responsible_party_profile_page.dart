import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../image_viewer.dart';
import '../../sign_in_page.dart';

class ResponsiblePartyProfilePage extends StatefulWidget {
  const ResponsiblePartyProfilePage({super.key});

  @override
  State<ResponsiblePartyProfilePage> createState() =>
      _ResponsiblePartyProfilePageState();
}

class _ResponsiblePartyProfilePageState
    extends State<ResponsiblePartyProfilePage> {
  String? userID = FirebaseAuth.instance.currentUser?.uid;

  Future<void> _logout() async {
    DatabaseReference resRef =
        FirebaseDatabase.instance.ref().child('responsibleParties');

    await resRef.child(userID!).update({
      'fcmToken': "-",
    });

    // ignore: empty_catches

    // Note: This callback is fired at each app startup and whenever a new
    // token is generated.

    await FirebaseAuth.instance.signOut();
    // Redirect the user to the SignInPage after logging out
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference rpDetailsRef =
        FirebaseDatabase.instance.ref().child('responsibleParties/$userID');
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          mediaQuery.size.height * 0.1,
        ),
        child: AppBar(
          elevation: 0,
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
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Padding(
            padding:
                EdgeInsets.fromLTRB(0, mediaQuery.size.height * 0.035, 0, 0),
            child: Text(
              'Profile',
              style: TextStyle(
                fontFamily: 'Rubik Bold',
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.size.height * 0.04,
                color: const Color(0xFF221540),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: StreamBuilder(
            stream: rpDetailsRef.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                // Getting values from database
                Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

                String profilePic = map['profilePicStatus'];
                String accountID = map['responsiblePartyID'];
                String firstName = map['firstName'];
                String lastName = map['lastName'];
                String fullName = "$firstName $lastName";
                String role = map['role'];
                String email = map['email'];
                String mobileNumber = map['mobileNumber'];

                return Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return DetailScreen(
                                imageUrl: profilePic,
                                projectID: accountID,
                              );
                            }));
                          },

                          // Image (kindly consult Jiiroo if you can't understand the code ty. ヾ(≧▽≦*)o)
                          child: Container(
                            decoration: BoxDecoration(
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: accountID,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Container(
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFF221540),
                                              width: 2,
                                            ),
                                          ),
                                          child: profilePic == "None"
                                              ? Image.asset(
                                                  'assets/images/no-image.png',
                                                  fit: BoxFit.cover,
                                                )
                                              : Image(
                                                  fit: BoxFit.cover,
                                                  image:
                                                      NetworkImage(profilePic),
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return const CircularProgressIndicator();
                                                  },
                                                  errorBuilder:
                                                      (context, object, stack) {
                                                    return const Icon(
                                                      Icons.error_outline,
                                                      color: Color(0xFF221540),
                                                    );
                                                  },
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10,
                                  ),
                                  child: Text(
                                    "$fullName",
                                    style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 20),
                                  child: Text(
                                    "$role",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width / 1,
                        margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Email: $email",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width / 1,
                        margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Mobile Number: $mobileNumber",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                    child: Text(
                  'Something went wrong.',
                ));
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        backgroundColor: const Color(0xFF221540),
        child: const Icon(Icons.logout),
      ),
    );
  }
}
