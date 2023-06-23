import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AdminInspectorCreationPage extends StatefulWidget {
  const AdminInspectorCreationPage({Key? key}) : super(key: key);

  @override
  State<AdminInspectorCreationPage> createState() =>
      _AdminInspectorCreationPageState();
}

class _AdminInspectorCreationPageState
    extends State<AdminInspectorCreationPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool validateFN = false;
  bool validateLN = false;
  bool validateRole = false;
  bool validateEmail = false;
  bool validatePW = false;
  bool validateCPW = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      // Validation successful, perform sign up
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      final firebaseApp = Firebase.app();
      final rtdb = FirebaseDatabase.instanceFor(
          app: firebaseApp,
          databaseURL:
              'https://quality-control-tracker-389614-default-rtdb.asia-southeast1.firebasedatabase.app/');

      try {
        // ignore: unused_local_variable
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? userID = FirebaseAuth.instance.currentUser?.uid;

        await rtdb.ref("inspectors/$userID").set({
          "firstName": firstName,
          "lastName": lastName,
          "role": "Inspector",
          "email": email,
          "mobileNumber": "-",
          "profilePicStatus": "None",
          "inspectorID": userID,
          "fcmInspectorToken": "-",
        });
        // Reset form fields after successful sign up
        _resetFields();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('The password provided is too weak.')),
          );
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('The account already exists for that email.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error.')),
        );
      }
    }
  }

  void _resetFields() {
    setState(() {
      _formKey.currentState?.reset();
      _firstNameController.clear();
      _lastNameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: () async {
        return false; // Disable back button
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFDCE4E9),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(mediaQuery.size.height * 0.1),
            child: AppBar(
                toolbarHeight: 60,
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
                title: Padding(
                  padding: EdgeInsets.fromLTRB(0, mediaQuery.size.height * 0.03,
                      mediaQuery.size.width * 0.06, 0),
                  child: Text(
                    'Add inspector',
                    style: TextStyle(
                      fontFamily: 'Rubik Bold',
                      fontSize: mediaQuery.size.height * 0.04,
                      color: const Color(0xFF221540),
                    ),
                  ),
                ))),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(30),
                  elevation: 5,
                  child: TextFormField(
                    controller: _firstNameController,
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
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16, // Adjust the vertical padding here
                        horizontal: 24, // Adjust the horizontal padding here
                      ),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          validateFN = true;
                        });
                        return null;
                      }
                      setState(() {
                        validateFN = false;
                      });
                      return null;
                    },
                  ),
                ),
                if (validateFN)
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Please enter your first name",
                      style: TextStyle(
                          fontFamily: 'Karla Regular',
                          fontSize: 14,
                          color: Colors.red),
                    ),
                  ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    // You can add more email validation logic here if needed
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration:
                      const InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text('Create Inspector Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
