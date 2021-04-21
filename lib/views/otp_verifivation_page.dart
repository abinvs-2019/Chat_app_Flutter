import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpVerification extends StatelessWidget {
  const OtpVerification({
    @required this.phoneNumber,
  });
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image(
                  image: AssetImage("android/assets/images/abcd_4x.webp"),
                ),
              ),
            ),
            Text("Verify Otp"),
            Row(
              children: [
                Text("Verfity Your otp sent to"),
                Text(
                  phoneNumber,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            OTPTextField(
              keyboardType: TextInputType.phone,
              length: 4,
              width: MediaQuery.of(context).size.width,
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldWidth: 50,
              fieldStyle: FieldStyle.underline,
              style: TextStyle(
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
