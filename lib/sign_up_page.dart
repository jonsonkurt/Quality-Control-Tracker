import 'package:firebase_auth/firebase_auth.dart';
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

  bool validateFN = false;
  bool validateLN = false;
  bool validateRole = false;
  bool validateEmail = false;
  bool validatePW = false;
  bool validateCPW = false;
  bool validatePWM = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      // Validation successful, perform sign up
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      try {
        // ignore: unused_local_variable
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String? userID = FirebaseAuth.instance.currentUser?.uid;

        await FirebaseDatabase.instance.ref("responsibleParties/$userID").set({
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
        leading: IconButton(
          onPressed: () {
            Navigator.push<void>(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const SignInPage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const SignInPage()),
            // );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF221540),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFDCE4E9),
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 30,
                bottom: MediaQuery.of(context).size.height / 30,
                left: MediaQuery.of(context).size.width / 30,
                right: MediaQuery.of(context).size.width / 30),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.push<void>(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SignInPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // Remove any padding
                        ),
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                            fontFamily: "Rubik Bold",
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: "Rubik Bold",
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF221540),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 5,
                        child: TextFormField(
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, // Adjust the vertical padding here
                              horizontal:
                                  24, // Adjust the horizontal padding here
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
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
                      const SizedBox(height: 15),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 5,
                        child: TextFormField(
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
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16, // Adjust the vertical padding here
                              horizontal:
                                  24, // Adjust the horizontal padding here
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                validateLN = true;
                              });
                              return null;
                            }
                            setState(() {
                              validateLN = false;
                            });
                            return null;
                          },
                        ),
                      ),
                      if (validateLN)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Please enter your last name",
                            style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 14,
                                color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 15),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 5,
                        child: DropdownButtonFormField<String>(
                          value: _selectedRole,
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Role',
                            labelStyle: const TextStyle(
                              fontFamily: "Karla Regular",
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 13, // Adjust the vertical padding here
                              horizontal:
                                  24, // Adjust the horizontal padding here
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          items: _roles.map((String role) {
                            return DropdownMenuItem<String>(
                              value: role,
                              child: Text(
                                role,
                              ),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                validateRole = true;
                              });
                              return null;
                            }
                            setState(() {
                              validateRole = false;
                            });
                            return null;
                          },
                          onChanged: (value) =>
                              setState(() => _selectedRole = value),
                        ),
                      ),
                      if (validateRole)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Please enter your role",
                            style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 14,
                                color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 15),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 5,
                        child: TextFormField(
                          controller: _emailController,
                          cursorColor: const Color(0xFF221540),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Email',
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
                              horizontal:
                                  24, // Adjust the horizontal padding here
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                validateEmail = true;
                              });
                              return null;
                            }
                            setState(() {
                              validateEmail = false;
                            });
                            return null;
                          },
                        ),
                      ),
                      if (validateEmail)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Please enter your email",
                            style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 14,
                                color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 15),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 5,
                        child: TextFormField(
                          controller: _passwordController,
                          cursorColor: const Color(0xFF221540),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Password',
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
                              horizontal:
                                  24, // Adjust the horizontal padding here
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
                            if (value == null || value.isEmpty) {
                              setState(() {
                                validatePW = true;
                              });
                              return null;
                            }
                            setState(() {
                              validatePW = false;
                            });
                            return null;
                          },
                        ),
                      ),
                      if (validatePW)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Please enter your password",
                            style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 14,
                                color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 15),
                      Material(
                        borderRadius: BorderRadius.circular(30),
                        elevation: 5,
                        child: TextFormField(
                          controller: _confirmPasswordController,
                          cursorColor: const Color(0xFF221540),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
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
                              horizontal:
                                  24, // Adjust the horizontal padding here
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
                                  _isconPasswordVisible =
                                      !_isconPasswordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_isconPasswordVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              setState(() {
                                validateCPW = true;
                              });
                              return null;
                            }
                            setState(() {
                              validateCPW = false;
                            });

                            if (value != _passwordController.text) {
                              setState(() {
                                validatePWM = true;
                              });
                              return null;
                            }
                            setState(() {
                              validatePWM = false;
                            });
                            return null;
                          },
                        ),
                      ),
                      if (validateCPW)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Please enter your password",
                            style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 14,
                                color: Colors.red),
                          ),
                        ),
                      if (validatePWM)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Passwords do not match",
                            style: TextStyle(
                                fontFamily: 'Karla Regular',
                                fontSize: 14,
                                color: Colors.red),
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
        ),
      ),
    );
  }
}
