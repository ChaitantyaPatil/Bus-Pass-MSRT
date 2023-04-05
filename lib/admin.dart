//https://www.kindacode.com/article/flutter-firebase-storage/
//https://medium.com/firebase-developers/firebase-firestore-crud-realtime-database-b476ca5f857c
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mega_project/login_page.dart';
import 'package:mega_project/view_pass.dart';

import 'auth_controller.dart';
import 'dummy.dart';

class admin extends StatefulWidget {
  const admin({super.key});

  @override
  State<admin> createState() => _adminState();
}

class _adminState extends State<admin> {
 

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(elevation: 0.0),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 200.0,
              decoration: const BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    const Text("Welcome Admin,",
                        style: TextStyle(
                            fontSize: 24.0,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 10.0),
                    const Text("Here are your Pass Requests",
                        style: TextStyle(fontSize: 16.0, color: Colors.white)),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 30.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const []),
                    SizedBox(
                      height: 100.0,
                    ),
                    Center(
                      child: Container(
                        height: h / 15,
                        width: w / 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Respond to button press
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ApprovalScreen()));
                          },
                          icon: Icon(Icons.assignment_ind_rounded, size: 18),
                          label: Text(" VIEW REQUESTS"),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: Colors.red)))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                     Center(
                       child: Container(
                                 height: h / 15,
                                   width: w / 2,
                                  child: OutlinedButton.icon(
                                       onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
                                        
                                       },
                                       icon: Icon(Icons.logout, size: 18),
                                       label: Text("Sign Out"),
                                       style: ButtonStyle(
                                         foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.red))),
                                       )),
                                ),
                     ),
                  
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
