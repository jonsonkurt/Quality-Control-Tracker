import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../sign_in_page.dart';
import 'admin_cred.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();

    // Redirect the user to the SignInPage after logging out
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  _showPasswordModal() {
    showModalBottomSheet<dynamic>(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      context: context,
      backgroundColor: const Color(0xFFDCE4E9),
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 25,
            right: MediaQuery.of(context).size.width / 20,
            left: MediaQuery.of(context).size.width / 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Wrap(
          spacing: 8.0, // gap between adjacent chips
          runSpacing: 4.0, // gap between lines
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                        horizontal: MediaQuery.of(context).size.height * 0.02,
                      ),
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        fontFamily: "Karla",
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      return null; // Return null if there is no error
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordConfirmController,
                    cursorColor: const Color(0xFF221540),
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.01,
                        horizontal: MediaQuery.of(context).size.height * 0.02,
                      ),
                      hintText: 'Confirm Password',
                      hintStyle: const TextStyle(
                        fontFamily: "Karla",
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _passwordController.text) {
                        return 'Password is not match';
                      }
                      return null; // Return null if there is no error
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: const Color(0xFF221540),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String password = _passwordController.text;

                        encryptPassword(password);

                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);

                        _passwordController.text = "";
                        _passwordConfirmController.text = "";

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password Updated'),
                          ),
                        );
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Update Password',
                          style: TextStyle(
                            fontFamily: 'Karla',
                            fontSize: 15,
                            color: Colors.white,
                          )),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
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
          title: Padding(
            padding: EdgeInsets.only(top: mediaQuery.size.height * 0.035),
            child: Text(
              ' ',
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
      body: SafeArea(
          child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.01,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 5,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ListTile(
                          title: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: Color(
                                          0xFF221540), // Set your desired color here
                                      child: Icon(
                                        Icons.admin_panel_settings,
                                        size: 40,
                                        color: Colors
                                            .white, // Set your desired color here
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15.0),
                                  Column(
                                    children: [
                                      Text(
                                        "Admin",
                                        style: TextStyle(
                                          fontFamily: 'Rubik Bold',
                                          fontSize: 30,
                                          color: Color(0xFF221540),
                                        ),
                                      ),
                                      Text(
                                        "Account",
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 15,
                                          color: Color(0xFF221540),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          color: Color(0xFF221540),
                          indent: 15,
                          endIndent: 15,
                        ),
                        const SizedBox(height: 10.0),
                        ElevatedButton(
                          onPressed: _showPasswordModal,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            backgroundColor: const Color(0xFF221540),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Text(
                              "Update Password",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ))),
      floatingActionButton: FloatingActionButton(
        onPressed: _logout,
        backgroundColor: const Color(0xFF221540),
        child: const Icon(Icons.logout),
      ),
    );
  }
}
