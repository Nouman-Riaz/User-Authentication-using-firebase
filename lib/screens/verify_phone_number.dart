import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_authentication/screens/post_screen.dart';

import '../../utils/utils.dart';
import '../buttons/round_button.dart';

class VerifyPhoneNumber extends StatefulWidget {
  final String verificationId;
  const VerifyPhoneNumber({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyPhoneNumber> createState() => _VerifyPhoneNumberState();
}

class _VerifyPhoneNumberState extends State<VerifyPhoneNumber> {
  final auth = FirebaseAuth.instance;
  bool loading = false;
  final verificationCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(hintText: 'Enter OTTP code here'),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundButton(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  print("Verify button tapped. Entered code: ${verificationCodeController.text}");
                  setState(() {
                    loading = true;
                  });

                  final credentials = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationCodeController.text.toString(),
                  );
                  try{
                    await auth.signInWithCredential(credentials);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => PostScreen()));
                  } catch (e) {
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
                })
          ],
        ),
      ),
    );
  }
}
