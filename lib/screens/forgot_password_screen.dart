import '../buttons/round_button.dart';
import '../utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController =  TextEditingController();
  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email'
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(title: 'Proceed', loading: loading,onTap: (){
              setState(() {
                loading = true;
              });
              auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage('We have sent an email to you, please check to reset your password');
              }).onError((error, stackTrace){
                setState(() {
                  loading = false;
                });
                Utils().toastMessage(error.toString());
              });
            }),
          ],
        ),
      ),
    );
  }
}