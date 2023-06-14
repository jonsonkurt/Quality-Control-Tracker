import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/loading_page.dart';
import 'sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _roles = [
    'Electrician',
    'Plumber',
    'Painter',
    'Mason',
    'Laborer',
    'Owner',
    'Project Manager',
    'Welder',
    'Carpenter',
    'Landscaper',
    'HVAC Technician'
  ];
  
  String? _selectedRole;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isconPasswordVisible = false;

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

        await rtdb.ref("responsibleParties/$userID").set({
          "firstName": firstName,
          "lastName": lastName,
          "role": _selectedRole,
          "email": email,
          "mobileNumber": "-",
          "profilePicStatus": "None",
          "responsiblePartyID": userID,
          "fcmToken": "-",
        });
        // Reset form fields after successful sign up
        _resetFields();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoadingPage()),
        );
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
      _selectedRole = null;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: const Color(0xFFDCE4E9),
      ),
      body: Container(
        color: const Color(0xFFDCE4E9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: "Rubik-Bold",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF221540),
                      ),
                    ),
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "Rubik-Bold",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(height: 30),  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextFormField(
                        controller: _firstNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'First Name',
                          labelStyle: const TextStyle(
                              fontFamily: "Karla-Regular",
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
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your first name';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), ),
                      child: TextFormField(
                        controller: _lastNameController,
                        style: const TextStyle(color: Colors.black),
                        decoration:  InputDecoration(
                          hintText: 'Last Name',
                          labelStyle: const TextStyle(
                              fontFamily: "Karla-Regular",
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
                              borderRadius: BorderRadius.circular(25.0),
                            ),  
                          ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your last name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), ),
                      child: DropdownButtonFormField<String>(
                        value: _selectedRole,
                        style: const TextStyle(color: Colors.black),
                        decoration:  InputDecoration(
                          hintText: 'Role',
                          labelStyle: const TextStyle(
                              fontFamily: "Karla-Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                            vertical: 13, // Adjust the vertical padding here
                            horizontal: 24, // Adjust the horizontal padding here
                          ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                        items: _roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(role,),
                          );
                        }).toList(),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                        onChanged: (value) => setState(() => _selectedRole = value),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), ),
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black),
                        decoration:  InputDecoration(
                          hintText: 'Email',
                          labelStyle: const TextStyle(
                              fontFamily: "Karla-Regular",
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
                              borderRadius: BorderRadius.circular(25.0),
                            ),),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          // You can add more email validation logic here if needed
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), ),
                      child: TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black),
                        decoration:  InputDecoration(
                         hintText: 'Password',
                         labelStyle: const TextStyle(
                              fontFamily: "Karla-Regular",
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
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                            color: const Color(0xFF221540),
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                         ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), ),
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        style: const TextStyle(color: Colors.black),
                        decoration:
                             InputDecoration(
                              hintText: 'Confirm Password',
                              labelStyle: const TextStyle(
                              fontFamily: "Karla-Regular",
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
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            suffixIcon: IconButton(
                            color: const Color(0xFF221540),
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _isconPasswordVisible = !_isconPasswordVisible;
                              });
                            },
                          ),
                              ),
                        obscureText: !_isconPasswordVisible,
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
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                          fixedSize: const Size(164, 50),
                          backgroundColor: const Color(0xFF221540),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Adjust the radius as needed
                          ),
                        ),
                      child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: "Karla-Bold",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ),
                  ),
                  const SizedBox(height: 60.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
