import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_authentication/screens/post_screen.dart';
import 'package:user_authentication/utils/utils.dart';

import '../buttons/round_button.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final auth = FirebaseAuth.instance;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Icon(
              Icons.email,
              size: 100,
              color: Colors.blue,
            ),
            SizedBox(height: 20),
            Text(
              'Email has been sent to verify your email address',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            RoundButton(
              title: 'continue',
              loading: loading,
              onTap: () async {
                final user = auth.currentUser;
                if (user != null) {
                  await user.reload(); // Refresh the user data
                  if (user.emailVerified) {
                    setState(() {
                      loading = true;
                    });
                    // Email is verified, navigate to the next screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PostScreen()), // Replace NextScreen with your actual next screen
                    );
                  } else {
                    setState(() {
                      loading = false;
                    });
                    // Email is not verified, show a message
                    Utils().toastMessage("Please verify your email address.");
                  }
                }
              },
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () async {
                final user = auth.currentUser;
                if (user != null) {
                  try {
                    await user.sendEmailVerification();
                    Utils().toastMessage("Verification email sent again");
                  } catch (e) {
                    print("Error sending verification email: $e");
                    Utils().toastMessage("Failed to send verification email");
                  }
                }
              },
              child: Text(
                'Resend Verification Email?',
                style:
                    TextStyle(decoration: TextDecoration.underline, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
