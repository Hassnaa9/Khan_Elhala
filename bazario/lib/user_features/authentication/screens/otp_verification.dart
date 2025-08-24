import 'dart:async';
import 'package:auto_route/annotations.dart';
import 'package:bazario/user_features/authentication/screens/widgets/logo_with_title.dart';
import 'package:bazario/user_features/authentication/screens/widgets/otp_form.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
@RoutePage()
class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  int _resendCooldown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCooldown = 60; // 60 seconds cooldown
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCooldown > 0) {
        setState(() {
          _resendCooldown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    final theme = Theme.of(context); // Get the current theme
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Theme-aware background
      body:  LogoWithTitle(
            title: 'Code Verification',
            subText: "please enter the code ,we just send to your email!",
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              OtpForm(
                onOtpSubmitted: (otp) {
                  print('OTP Submitted: $otp'); // Debug print
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            ],
          )
      );
  }
}