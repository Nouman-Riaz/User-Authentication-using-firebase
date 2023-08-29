import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:user_authentication/screens/verify_phone_number.dart';

import '../buttons/round_button.dart';
import '../utils/utils.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  final phoneNumberController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login With Phone Number'),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration:const InputDecoration(
                  hintText: '+92xx xxxxxxx'
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundButton(title: 'Verify',loading: loading,onTap: (){
              setState(() {
                loading = true;
              });
              auth.verifyPhoneNumber(
                  phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){
                    setState(() {
                      loading = false;
                    });
                  },
                  verificationFailed: (e){
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  },
                  codeSent: (String verificationId, int? token){
                    print("Verification code sent. Verification ID: $verificationId");
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyPhoneNumber(verificationId: verificationId,)));
                    setState(() {
                      loading = false;
                    });
                  },
                  codeAutoRetrievalTimeout: (e){
                    setState(() {
                      loading = false;
                    });
                    Utils().toastMessage(e.toString());
                  }
              );
            },),

          ],
        ),
      ),
    );
  }
}
