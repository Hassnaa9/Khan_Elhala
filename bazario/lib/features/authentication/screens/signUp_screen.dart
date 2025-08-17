// dart format width=80
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/app/app_router.gr.dart';
import 'package:bazario/features/authentication/screens/signIn_screen.dart';
import 'package:bazario/features/authentication/screens/widgets/login_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import '../../../utils/constants/colors.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false; // Add a state variable for loading

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // A helper method to handle form submission and Firebase registration
  void _submitForm() async {
    // First, validate the form fields
    if (_formKey.currentState!.validate()) {
      // Set loading state to true and disable the button
      setState(() {
        _isLoading = true;
      });

      try {
        // Use Firebase Auth to create a new user with email and password
        final UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Get the user's unique ID (UID) from the UserCredential
        final user = userCredential.user;
        if (user != null) {
          // Store additional user data (like username) in Firestore.
          // The document ID is set to the user's UID for easy lookup.
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'username': _userNameController.text.trim(),
            'email': _emailController.text.trim(),
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        // After successful registration and data storage, navigate.
        context.router.replace((LocationRouteViewBody()));
      } on FirebaseAuthException catch (e) {
        // Handle Firebase-specific errors and show a user-friendly message
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'An account already exists for that email.';
        } else {
          message = 'An error occurred: ${e.message}';
        }

        // Display the error message in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
          ),
        );
      } catch (e) {
        // Catch any other potential errors during Firestore operations
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save user data: $e'),
          ),
        );
      } finally {
        // Reset the loading state regardless of the outcome
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.08),
                Text(
                  "Fill your information below, or register with your social account",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Urbanist",
                      color: MyColors.kPrimaryColor),
                ),
                SizedBox(height: screenHeight * 0.04),
                _buildTextField(_userNameController, "Enter your name"),
                _buildTextField(_emailController, "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator),
                _buildPasswordField(_passwordController, "Enter your password"),
                _buildPasswordField(
                    _confirmPasswordController, "Confirm your password",
                    confirm: true),
                SizedBox(height: screenHeight * 0.02),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _submitForm, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(screenWidth - 44, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                      : const Text("Sign Up"),
                ),
                SizedBox(height: screenHeight * 0.02),
                const Divider(thickness: 1),
                const SizedBox(height: 5),
                const Text("Or Sign Up with",
                    style: TextStyle(color: Colors.grey)),
                const Divider(thickness: 1),
                SizedBox(height: screenHeight * 0.02),
                login_methods(screenWidth: screenWidth, screenHeight: screenHeight),
                TextButton(
                  onPressed: () => context.router.replace(SignInRoute()),
                  child: RichText(
                    text: const TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Urbanist"),
                      children: [
                        TextSpan(
                            text: "Sign in",
                            style: TextStyle(color: MyColors.kPrimaryColor)),
                      ],
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

  Widget _buildTextField(TextEditingController controller, String hintText,
      {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xffE8ECF4),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide.none),
        ),
        keyboardType: keyboardType,
        validator: validator ??
                (value) {
              return value == null || value.isEmpty
                  ? "This field is required."
                  : null;
            },
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hintText,
      {bool confirm = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: !_isPasswordVisible,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: const Color(0xffE8ECF4),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide.none),
          suffixIcon: IconButton(
            icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "This field is required.";
          if (!confirm) {
            if (value.length < 8)
              return "Password must be at least 8 characters long.";
            if (!RegExp(r'[A-Z]').hasMatch(value))
              return "Password must contain at least one uppercase letter.";
            if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value))
              return "Password must contain at least one special character.";
          } else if (value != _passwordController.text) {
            return "Passwords do not match.";
          }
          return null;
        },
      ),
    );
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Please enter your email.";
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value))
      return "Please enter a valid email address.";
    return null;
  }
}
