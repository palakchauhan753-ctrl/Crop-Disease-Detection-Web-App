import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'language_selection.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState
    extends State<LoginPage> {

  // 🔵 CONTROLLERS
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;

  // 👁 PASSWORD VISIBILITY
  bool obscurePassword = true;

  // 🔥 LOGIN FUNCTION
  Future<void> loginUser() async {

    // ✅ EMPTY FIELD CHECK
    if (email.text.trim().isEmpty ||
        password.text.trim().isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Please enter email and password",
          ),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() => loading = true);

    try {

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email: email.text.trim(),

        password:
        password.text.trim(),
      );

      setState(() => loading = false);

      // ✅ CLOSE KEYBOARD
      FocusScope.of(context)
          .unfocus();

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              LanguageSelection(

                userName: name.text,

                userPhone:
                email.text,
              ),
        ),
      );

    } on FirebaseAuthException catch (e) {

      setState(() => loading = false);

      String errorMessage =
          "Login failed";

      // ✅ INVALID EMAIL
      if (e.code ==
          'invalid-email') {

        errorMessage =
        "Invalid email format";
      }

      // ✅ WRONG PASSWORD
      else if (e.code ==
          'wrong-password') {

        errorMessage =
        "Incorrect email or password";
      }

      // ✅ USER NOT FOUND
      else if (e.code ==
          'user-not-found') {

        errorMessage =
        "Incorrect email or password";
      }

      // ✅ INVALID CREDENTIAL
      else if (e.code ==
          'invalid-credential') {

        errorMessage =
        "Incorrect email or password";
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(errorMessage),

          backgroundColor:
          Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {

    name.dispose();
    email.dispose();
    password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // 🌈 GRADIENT BACKGROUND
      body: Container(

        decoration: BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [

              Colors.green.shade200,
              Colors.white,
            ],
          ),
        ),

        child: Center(

          child: SingleChildScrollView(

            padding:
            const EdgeInsets.all(20),

            child: Card(

              elevation: 8,

              shape:
              RoundedRectangleBorder(

                borderRadius:
                BorderRadius.circular(25),
              ),

              child: Padding(

                padding:
                const EdgeInsets.all(25),

                child: Column(

                  mainAxisSize:
                  MainAxisSize.min,

                  children: [

                    // 🌿 LOGO
                    CircleAvatar(

                      radius: 45,

                      backgroundColor:
                      Colors.green.shade100,

                      child: const Icon(

                        Icons.agriculture,

                        size: 45,

                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // 🌱 TITLE
                    const Text(

                      "Crop Doctor",

                      style: TextStyle(

                        fontSize: 24,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(

                      "Smart Farming Starts Here 🌿",

                      style: TextStyle(

                        color: Colors.grey,

                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 👤 NAME
                    TextField(

                      controller: name,

                      decoration:
                      InputDecoration(

                        labelText:
                        "Full Name",

                        prefixIcon:
                        const Icon(
                          Icons.person,
                        ),

                        filled: true,

                        fillColor:
                        Colors.grey.shade100,

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          BorderSide.none,
                        ),

                        focusedBorder:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(

                            color:
                            Colors.green,

                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 📧 EMAIL
                    TextField(

                      controller: email,

                      keyboardType:
                      TextInputType
                          .emailAddress,

                      decoration:
                      InputDecoration(

                        labelText:
                        "Email",

                        prefixIcon:
                        const Icon(
                          Icons.email,
                        ),

                        filled: true,

                        fillColor:
                        Colors.grey.shade100,

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          BorderSide.none,
                        ),

                        focusedBorder:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(

                            color:
                            Colors.green,

                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔒 PASSWORD
                    TextField(

                      controller:
                      password,

                      obscureText:
                      obscurePassword,

                      decoration:
                      InputDecoration(

                        labelText:
                        "Password",

                        prefixIcon:
                        const Icon(
                          Icons.lock,
                        ),

                        // 👁 EYE BUTTON
                        suffixIcon:
                        IconButton(

                          icon: Icon(

                            obscurePassword

                                ? Icons
                                .visibility_off

                                : Icons
                                .visibility,
                          ),

                          onPressed: () {

                            setState(() {

                              obscurePassword =
                              !obscurePassword;
                            });
                          },
                        ),

                        filled: true,

                        fillColor:
                        Colors.grey.shade100,

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          BorderSide.none,
                        ),

                        focusedBorder:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(

                            color:
                            Colors.green,

                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔵 LOGIN BUTTON
                    SizedBox(

                      width:
                      double.infinity,

                      height: 55,

                      child:
                      ElevatedButton(

                        style:
                        ElevatedButton.styleFrom(

                          elevation: 5,

                          shadowColor:
                          Colors.green,

                          backgroundColor:
                          Colors.green,

                          shape:
                          RoundedRectangleBorder(

                            borderRadius:
                            BorderRadius.circular(15),
                          ),
                        ),

                        onPressed:
                        loading
                            ? null
                            : loginUser,

                        child: loading

                            // 🔄 LOADING SPINNER
                            ? const SizedBox(

                          height: 25,
                          width: 25,

                          child:
                          CircularProgressIndicator(

                            color:
                            Colors.white,

                            strokeWidth:
                            3,
                          ),
                        )

                            : const Text(

                          "Login",

                          style:
                          TextStyle(

                            fontSize: 17,

                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // 🔥 SIGNUP
                    TextButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                            const SignupPage(),
                          ),
                        );
                      },

                      child: const Text(

                        "Create New Account",

                        style: TextStyle(

                          color:
                          Colors.green,

                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}