import 'package:user_authentication/screens/email_verification_screen.dart';
import 'package:user_authentication/screens/login_screen.dart';
import 'package:user_authentication/screens/post_screen.dart';
import '../utils/utils.dart';
import '../buttons/round_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _passwordVisible;
  bool loading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  void signup() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      _auth
          .createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString())
          .then((value) async{
        final user = _auth.currentUser;
        if (user != null) {
          try {
            await user.sendEmailVerification();
            Utils().toastMessage("Verification email sent");
          } catch (e) {
            print("Error sending verification email: $e");
            Utils().toastMessage("Failed to send verification email");
          }
        }
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EmailVerificationScreen()));
        setState(() {
          loading = false;
        }
        );
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUp'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green, width: 1),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red, width: 1),
                          ),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          if (!EmailValidator.validate(value)){
                            setState(() {
                              loading = false;
                            });
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            hintText: 'password',
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.blue, width: 1),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.green, width: 1),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red, width: 1),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) return 'Enter Password';
                            return null;
                          }),
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                title: 'Sign Up',
                loading: loading,
                onTap: () => signup(),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginScreen()));
                    },
                    child: const Text('Login'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
