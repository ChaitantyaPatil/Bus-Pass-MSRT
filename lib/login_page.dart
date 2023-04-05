// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_key_in_widget_constructors
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mega_project/admin.dart';
import 'auth_controller.dart';

import 'singup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              height: 230,
              width: w,
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 1.6,
                  //fit: BoxFit.cover,
                  image: AssetImage("images/msrtc_launch.jpg"),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              width: w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to MSRTC",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Maharashtra State Road Transport Corporation",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 30),
                  textField(
                      controllers: emailController,
                      text: "Email",
                      icon: Icon(Icons.email, color: Colors.black)),
                  SizedBox(height: 20),
                  textField(
                      controllers: passwordController,
                      text: "Password",
                      icon: Icon(Icons.password, color: Colors.black)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: Container()),
                      Text(
                        "Forgot your Password?",
                        style: TextStyle(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 35),
            GestureDetector(
              onTap: () {
                if (emailController.text.contains('admin@email.com')) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => admin()));
                  emailController.clear();
                  passwordController.clear();
                } else {
                  AuthController.instance.login(emailController.text.trim(),
                      passwordController.text.trim());
                  emailController.clear();
                  passwordController.clear();
                }
              },
              child: Container(
                height: h / 14,
                width: w / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("images/loginbtn.png"),
                  ),
                ),
                child: Center(
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don\'t have an account?",
                  style: TextStyle(
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text(
                    " Create",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                       decoration:
                          TextDecoration.underline, // Add underline here
                      decorationColor: Color.fromARGB(255, 0, 0, 0), // Set underline color
                      decorationThickness: 1,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container textField(
      {required Icon icon,
      required String text,
      required TextEditingController controllers}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            spreadRadius: 10,
            offset: Offset(1, 1),
            color: Colors.grey.withOpacity(0.2),
          )
        ],
      ),
      child: TextField(
        controller: controllers,
        decoration: InputDecoration(
          hintText: text,
          prefixIcon: icon,
          focusedBorder: oulineInputBorder(),
          enabledBorder: oulineInputBorder(),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder oulineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    );
  }
}
