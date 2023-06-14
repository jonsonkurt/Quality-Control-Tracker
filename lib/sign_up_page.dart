import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quality_control_tracker/loading_page.dart';

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
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
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
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(labelText: 'Role'),
                items: _roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
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
                child: const Text('Sign Up'),
              ),
              TextButton(
                onPressed: () {
                  // Implement sign-in button action here
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
