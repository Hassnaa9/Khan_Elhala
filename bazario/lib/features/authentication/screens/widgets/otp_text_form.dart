import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_form.dart';

class OtpTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final bool autofocus;

  const OtpTextFormField({
    Key? key,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onSaved,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffC5BEBE),
        borderRadius: BorderRadius.circular(10)
      ),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focusNode,
        controller: controller,
        onChanged: onChanged,
        onSaved: onSaved,
        autofocus: autofocus,
        obscureText: false, // Show numbers for OTP
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineSmall,
        decoration: otpInputDecoration,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '';
          }
          return null;
        },
      ),
    );
  }
}