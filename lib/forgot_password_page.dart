import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/sign_in_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool validateEmail = false;

  @override
  void dispose() {
    _emailController.dispose();
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInPage()),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF221540),
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          color: const Color(0xFFDCE4E9),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Forgot",
                    style: TextStyle(
                      fontFamily: "Rubik-Bold",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF221540),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Password",
                    style: TextStyle(
                      fontFamily: "Rubik-Bold",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF221540),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
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
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      String email = _emailController.text;
                      if (email.isNotEmpty) {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                        _emailController.clear();
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset link sent.'),
                          ),
                        );
                      } else {
                        setState(() {
                          validateEmail = true;
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 50),
                    backgroundColor: const Color(0xFF221540),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          30), // Adjust the radius as needed
                    ),
                  ),
                  child: const Text(
                    'Send Reset Link',
                    style: TextStyle(
                      fontFamily: "Karla-Bold",
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
