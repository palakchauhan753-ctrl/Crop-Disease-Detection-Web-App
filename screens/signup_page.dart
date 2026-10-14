import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() =>
      _SignupPageState();
}

class _SignupPageState
    extends State<SignupPage> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  final AuthService _authService =
  AuthService();

  bool loading = false;

  // 👁 PASSWORD VISIBILITY
  bool obscurePassword = true;

  String passwordStrength = "";

  // 🔥 PASSWORD STRENGTH CHECKER
  void checkPassword(String password) {

    String strength;

    if (password.length < 6) {

      strength = "Weak 🔴";

    } else if (password.length < 10) {

      strength = "Medium 🟠";

    } else if (password.contains(
        RegExp(r'[A-Z]')) &&
        password.contains(
            RegExp(r'[0-9]'))) {

      strength = "Strong 🟢";

    } else {

      strength = "Medium 🟠";
    }

    setState(() {

      passwordStrength = strength;
    });
  }

  // 🔥 SIGNUP FUNCTION
  void signup() async {

    if (emailController.text
        .trim()
        .isEmpty ||
        passwordController.text
            .trim()
            .isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Please fill all fields",
          ),

          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    setState(() => loading = true);

    var user =
    await _authService.signUp(

      emailController.text.trim(),

      passwordController.text.trim(),
    );

    setState(() => loading = false);

    if (user != null) {

      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Signup Successful",
          ),

          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
            "Signup Failed",
          ),

          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
          "Create Account",
        ),

        centerTitle: true,

        backgroundColor: Colors.green,
      ),

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

                      "Create your farmer account 🌱",

                      style: TextStyle(

                        color: Colors.grey,

                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 📧 EMAIL
                    TextField(

                      controller:
                      emailController,

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

                        focusedBorder:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(

                            color: Colors.green,
                            width: 2,
                          ),
                        ),

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔒 PASSWORD
                    TextField(

                      controller:
                      passwordController,

                      obscureText:
                      obscurePassword,

                      onChanged:
                      checkPassword,

                      decoration:
                      InputDecoration(

                        labelText:
                        "Password",

                        prefixIcon:
                        const Icon(
                          Icons.lock,
                        ),

                        // 👁 SHOW/HIDE BUTTON
                        suffixIcon:
                        IconButton(

                          icon: Icon(

                            obscurePassword

                                ? Icons.visibility_off
                                : Icons.visibility,
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

                        focusedBorder:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          const BorderSide(

                            color: Colors.green,
                            width: 2,
                          ),
                        ),

                        border:
                        OutlineInputBorder(

                          borderRadius:
                          BorderRadius.circular(15),

                          borderSide:
                          BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔥 PASSWORD STRENGTH
                    Align(

                      alignment:
                      Alignment.centerLeft,

                      child: Text(

                        passwordStrength,

                        style: TextStyle(

                          fontWeight:
                          FontWeight.bold,

                          color:
                          passwordStrength
                              .contains(
                              "Weak")

                              ? Colors.red

                              : passwordStrength
                              .contains(
                              "Medium")

                              ? Colors.orange

                              : Colors.green,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // 🔵 SIGNUP BUTTON
                    SizedBox(

                      width:
                      double.infinity,

                      height: 55,

                      child: ElevatedButton(

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
                            : signup,

                        // 🔄 LOADING SPINNER
                        child: loading

                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )

                            : const Text(

                          "Signup",

                          style:
                          TextStyle(

                            fontSize: 17,

                            fontWeight:
                            FontWeight.bold,
                          ),
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