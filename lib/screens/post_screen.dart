import 'package:flutter/material.dart';
import 'package:user_authentication/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/utils.dart';
class PostScreen extends StatelessWidget {
  PostScreen({Key? key}) : super(key: key);
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Screen'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout_outlined)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Logged In Successfully',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),)),
        ],
      ),
    );
  }
}
