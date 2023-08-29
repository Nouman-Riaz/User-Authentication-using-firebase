import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:user_authentication/screens/signup_screen.dart';
import 'forgot_password_screen.dart';
import 'login_with_phone_number.dart';
import 'post_screen.dart';

import '../buttons/round_button.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 23),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
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
                              borderSide:
                              BorderSide(color: Colors.blue, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.green, width: 1),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: Colors.red, width: 1),
                            ),
                            prefixIcon: Icon(Icons.email),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email';
                            }
                            if (!EmailValidator.validate(value)) {
                              setState(() {
                                loading = false;
                              });
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
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
                                borderSide:
                                BorderSide(color: Colors.red, width: 1),
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
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              }
                              return null;
                            }),
                      ],
                    )),
                const SizedBox(
                  height: 40,
                ),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      _auth
                          .signInWithEmailAndPassword(
                          email: emailController.text.toString(),
                          password: passwordController.text.toString())
                          .then((value) {
                        Utils().toastMessage(value.user!.email.toString());
                        setState(() {
                          loading = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostScreen()));
                      }).onError((error, stackTrace) {
                        setState(() {
                          loading = false;
                        });
                        debugPrint(error.toString());
                        Utils().toastMessage(error.toString());
                      });
                    }

                  },
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot Password",style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: const Text("SignUp"),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginWithPhoneNumber()));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: Colors.blue,
                        )),
                    child: const Center(
                      child: Text('Login with phone number'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
