import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/forgot_password_page.dart';
import 'package:quality_control_tracker/view/admin/admin_cred.dart';
import 'package:quality_control_tracker/welcome_page.dart';
import 'sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool validateEmail = false;
  bool validatePassword = false;

  @override
  Widget build(BuildContext context) {
    void toLoading() {
      Navigator.pushNamed(context, '/loading');
    }

    void toAdmin() {
      Navigator.pushNamed(context, '/adminDashboard');
    }

    return Scaffold(
      backgroundColor: const Color(0xFFDCE4E9),
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
                    const WelcomePage(),
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
            //   MaterialPageRoute(builder: (context) => const WelcomePage()),
            // );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF221540),
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFDCE4E9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // Wrap Column with SingleChildScrollView
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "Rubik",
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF221540),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push<void>(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const SignUpPage(),
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
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: "Rubik",
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      elevation: 5,
                      child: TextFormField(
                        controller: _emailController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelStyle: const TextStyle(
                            fontFamily: "Rubik-Bold",
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                            setState(() {
                              validateEmail = true;
                            });
                            return null;
                          }
                          setState(() {
                            validateEmail = false;
                          });
                          return null; // Return null if there is no error
                        },
                      ),
                    ),
                    if (validateEmail)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Please enter your email",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 15.0),
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      elevation: 5,
                      child: TextFormField(
                        controller: _passwordController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          hintText: 'Password',
                          labelStyle: const TextStyle(
                            fontFamily: "Rubik-Bold",
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
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
                              validatePassword = true;
                            });
                            return null;
                          }
                          setState(() {
                            validatePassword = false;
                          });
                          return null; // Return null if there is no error
                        },
                      ),
                    ),
                    if (validatePassword)
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Please enter your password",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const ForgotPasswordPage(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                var begin = const Offset(0.0, 1.0);
                                var end = Offset.zero;
                                var curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition(
                                  position: animation.drive(tween),
                                  child: child,
                                );
                              },
                            ),
                          ); // Handle sign up
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(
                            fontFamily: "Karla-Light",
                            color: Color(0xFF221540),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Perform sign-in logic
                            // _performSignIn();
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            String getCred = decodingCred();

                            bool isPasswordCorrect =
                                await checkPassword(password);

                            if (email == getCred) {
                              if (isPasswordCorrect) {
                                toAdmin();
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Admin password is incorrect.'),
                                  ),
                                );
                              }
                            } else {
                              try {
                                // ignore: unused_local_variable
                                final credential = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);

                                // Clear text fields after successful sign-in
                                _emailController.clear();
                                _passwordController.clear();

                                // // ignore: use_build_context_synchronously
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const LoadingPage()));
                                toLoading();
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('No user found for that email.'),
                                    ),
                                  );
                                } else if (e.code == 'wrong-password') {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Wrong password provided for that user.'),
                                    ),
                                  );
                                }
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(164, 53),
                          backgroundColor: const Color(0xFF221540),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                30), // Adjust the radius as needed
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: "Karla-Bold",
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> _performSignIn() async {
  //   String email = _emailController.text;
  //   String password = _passwordController.text;
  //   String getCred = decodingCred();

  //   bool isPasswordCorrect = await checkPassword(password);

  //   if (email == getCred) {
  //     // print("I/'m an admin");
  //     if (isPasswordCorrect) {
  //       // ignore: use_build_context_synchronously
  //       Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => const AdminBottomNavigation()));
  //     } else {
  //       // ignore: use_build_context_synchronously
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Admin password is incorrect.'),
  //         ),
  //       );
  //     }
  //   } else {
  //     try {
  //       // ignore: unused_local_variable
  //       final credential = await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: email, password: password);

  //       // Clear text fields after successful sign-in
  //       _emailController.clear();
  //       _passwordController.clear();

  //       // ignore: use_build_context_synchronously
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => const LoadingPage()));
  //     } on FirebaseAuthException catch (e) {
  //       if (e.code == 'user-not-found') {
  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('No user found for that email.'),
  //           ),
  //         );
  //       } else if (e.code == 'wrong-password') {
  //         // ignore: use_build_context_synchronously
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Wrong password provided for that user.'),
  //           ),
  //         );
  //       }
  //     }
  //   }
  // }
}
