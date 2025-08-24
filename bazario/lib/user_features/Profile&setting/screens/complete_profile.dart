import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
@RoutePage()
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(text: '+201007765432');
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 70),
            Text(
              'Complete your profile',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: "Urbanist",
                color: MyColors.kPrimaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * .02),
            Center(
              child: // Enhanced code for the profile avatar
                  Container(
                width: screenWidth * 0.429,
                height: screenHeight * 0.146,
                decoration: BoxDecoration(
                  color: Colors.white, // The background color
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * .9),
                    topRight: Radius.circular(screenWidth * .9),
                    bottomLeft: Radius.circular(screenHeight*.9),
                    bottomRight: Radius.circular(screenHeight*.9)
                  ), // Creates the oval shape
                  border: Border.all(
                    color: MyColors.kPrimaryColor, // The border color
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: screenHeight *
                        0.1, // Adjust the icon size based on screen height
                    color: MyColors.kPrimaryColor, // The icon color
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * .02),
            _buildTextField(
              label: 'Username',
              controller: _usernameController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Phone Number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Gender',
              controller: _genderController,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'City',
              controller: _cityController,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Implement profile completion logic here
                print('Username: ${_usernameController.text}');
                print('Phone: ${_phoneController.text}');
                print('Gender: ${_genderController.text}');
                print('City: ${_cityController.text}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.kPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Complete profile',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: "Poppins"
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: MyColors.kPrimaryColor,
            fontFamily: "Poppins"
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xffe3e2e2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
}
