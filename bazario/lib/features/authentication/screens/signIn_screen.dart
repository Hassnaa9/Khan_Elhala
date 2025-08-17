import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bazario/features/authentication/screens/signUp_screen.dart';
import 'package:bazario/features/authentication/screens/widgets/login_methods.dart';
import 'package:flutter/material.dart';

import '../../../app/app_router.gr.dart';
import '../../../utils/constants/colors.dart';
@RoutePage()
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // A helper method to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with registration logic
      print('Form is valid. User data:');
      print('Email: ${_emailController.text}');
      print('Password: ${_passwordController.text}');
      // Here you would typically call a service to handle the registration
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
                  "Welcome back! You have been missed!", // Corrected text
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: "Urbanist",
                      color: MyColors.kPrimaryColor),
                ),
                SizedBox(height: screenHeight * 0.04),
                _buildTextField(_emailController, "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    validator: _emailValidator),
                _buildPasswordField(_passwordController, "Enter your password"),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(color: Color(0xff6A707C),fontSize: 14,fontFamily: "Urbanist"),
                          ))
                    ]),
                SizedBox(height: screenHeight * 0.04),
                ElevatedButton(
                  onPressed: (){
                    _submitForm();
                    context.router.replace(HomeRoute());
                  } ,// Calls the new submit method
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.kPrimaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(screenWidth - 44, screenHeight * 0.07),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Sign In"),
                ),
                // SizedBox(height: screenHeight * 0.01),
                const Divider(thickness: 1),
                const SizedBox(height: 5),
                const Text("Or Sign in with",
                    style: TextStyle(color: Colors.grey)),
                const Divider(thickness: 1),
                SizedBox(height: screenHeight * 0.02),
                login_methods(
                    screenWidth: screenWidth, screenHeight: screenHeight),
                SizedBox(height: screenHeight*.0999,),
                TextButton(
                  onPressed: () =>context.router.replace(SignUpRoute()),
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontFamily: "Urbanist"),
                      children: [
                        TextSpan(
                            text: "Sign Up",
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
