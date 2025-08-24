import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import 'otp_text_form.dart';

class OtpForm extends StatefulWidget {
  final Function(String) onOtpSubmitted; // Callback to send OTP to parent

  const OtpForm({super.key, required this.onOtpSubmitted});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (_) => FocusNode());
    _controllers = List.generate(4, (_) => TextEditingController());
  }

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitOtp() {
    if (_formKey.currentState!.validate()) {
      final otp = _controllers.map((c) => c.text).join();
      widget.onOtpSubmitted(otp);
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) {
              return SizedBox(
                width: screenWidth * 0.12,
                child: OtpTextFormField(
                  focusNode: _focusNodes[index],
                  controller: _controllers[index],
                  onChanged: (value) {
                    if (value.length == 1 && index < 5) {
                      _focusNodes[index + 1].requestFocus();
                    } else if (value.isEmpty && index > 0) {
                      _focusNodes[index - 1].requestFocus();
                    } else if (value.length == 1 && index == 5) {
                      _focusNodes[index].unfocus();
                      _submitOtp(); // Auto-submit on last digit
                    }
                  },
                  onSaved: (pin) {},
                  autofocus: index == 0,
                ),
              );
            }),
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Don’t receive code ? Re-send ",
                style: TextStyle(color: Colors.grey,fontFamily: "Urbanist",fontSize: 14),
              ),
              TextButton(
                onPressed: (){},
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: MyColors.kPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.04),
          ElevatedButton(
            onPressed: _submitOtp,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: MyColors.kPrimaryColor,
              foregroundColor: Colors.white,
              minimumSize: Size(screenWidth *.866, screenHeight * .067),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            child: const Text("Verify",style: TextStyle(fontFamily: "Urbanist",fontSize: 18),),
          ),
        ],
      ),
    );
  }
}

const InputDecoration otpInputDecoration = InputDecoration(
  filled: false,
  border: UnderlineInputBorder(),
  hintText: "0",
);