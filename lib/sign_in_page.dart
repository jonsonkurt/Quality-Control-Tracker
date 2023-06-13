import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/forgot_password_page.dart';
import 'package:quality_control_tracker/loading_page.dart';
import 'package:quality_control_tracker/view/admin/admin_bottom_navigation_bar.dart';
import 'package:quality_control_tracker/view/admin/admin_cred.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  // Add additional email validation logic if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
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
                  // Add additional password validation logic if needed
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Perform sign-in logic
                    _performSignIn();
                  }
                },
                child: const Text('Sign In'),
              ),
              TextButton(
                onPressed: () {
                  // ignore: use_build_context_synchronously
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text('Forgot Password?'),
              ),
              TextButton(
                onPressed: () {
                  // ignore: use_build_context_synchronously
                  Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _performSignIn() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String getCred = decodingCred();

    if (email == getCred && password == getCred) {
      // ignore: use_build_context_synchronously
      Navigator.push<void>(
          context,
          MaterialPageRoute(
              builder: (context) => const AdminBottomNavigation()));
    } else {
      try {
        // ignore: unused_local_variable
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        // Clear text fields after successful sign-in
        _emailController.clear();
        _passwordController.clear();

        // ignore: use_build_context_synchronously
        Navigator.push<void>(context,
            MaterialPageRoute(builder: (context) => const LoadingPage()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No user found for that email.'),
            ),
          );
        } else if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Wrong password provided for that user.'),
            ),
          );
        }
      }
    }
  }
}
