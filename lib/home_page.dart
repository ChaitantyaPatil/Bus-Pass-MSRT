// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_key_in_widget_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_project/admin.dart';
import 'package:mega_project/new_pass_page.dart';
import 'package:mega_project/renew_pass.dart';
import 'package:mega_project/track.dart';
import 'package:mega_project/view_pass.dart';
import 'dart:async';
import 'auth_controller.dart';

class homePage extends StatefulWidget {
  String email;
  homePage({required this.email});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  // const WelcomePage({Key? key}) : super(key: key);
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
        'MSRTC Bus Pass ',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                      ),
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.black,
                        backgroundImage: AssetImage("images/img1.png"),
                      ),
                    ],
                  ),
                ),
                Container(
                  //width: w,
                  margin: EdgeInsets.only(left: 65, top: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Welcome",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            fontFamily: 'font/Roboto-Black.ttf',
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            SizedBox(
              height: 70.0,
            ),
            Container(
                height: h / 15,
                width: w / 2,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    // Check the payment status in Firestore
                    final doc = await FirebaseFirestore.instance
                        .collection('Info')
                        .doc(uid)
                        .get();
                    final paymentStatus = doc.data()?['Payment Status'];
                    if (paymentStatus == true) {
                      // Navigate to the next page
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ViewPassPage(uid: uid)));
                    } else {
                      // Show an error message
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text("Error"),
                          content: Text(
                              "You need to complete registration and payment first."),
                          actions: [
                            TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ))),
                          ],
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.assignment_ind_rounded, size: 18),
                  label: Text(" VIEW PASS"),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        side: BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
              height: h / 15,
              width: w / 2,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Info')
                      .doc(uid)
                      .get();
                  if (snapshot.exists) {
                    final data = snapshot.data() as Map<String, dynamic>;
                    final passEndingDate =
                        DateTime.parse(data['Pass Ending Date']);
                    final passEndingDateOnly = DateFormat('dd-MMM-yyyy')
                        .format(DateTime.parse(data['Pass Ending Date']));
                    final passStatus = data['approved'];

                    if (DateTime.now().isBefore(passEndingDate) &&
                        passStatus == true) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Pass Already Active'),
                            content: Text(
                                'You already have an active pass. Please apply after $passEndingDateOnly'),
                            actions: [
                              TextButton(
                                  child: Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: BorderSide(color: Colors.red),
                                    ),
                                  ))),
                            ],
                          );
                        },
                      );
                    }
                  } else {
                    // The document doesn't exist, so navigate to the next page
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Newpass(
                          email: widget.email,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(Icons.fiber_new_rounded, size: 18),
                label: Text("APPLY FOR NEW PASS"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: h / 15,
              width: w / 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Renewpass(
                            uid: uid,
                          )));
                  // Respond to button press
                },
                icon: Icon(Icons.change_circle_rounded, size: 18),
                label: Text("RENEW OLD PASS"),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    side: BorderSide(color: Colors.red),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              height: h / 15,
              width: w / 2,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final snapshot = await FirebaseFirestore.instance
                      .collection('Info')
                      .doc(uid)
                      .get();
                  final requestDetails = snapshot.data();
                  final status = requestDetails?['approved'];
                  print(status);

                  if (status == null || status == "") {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Request Pending'),
                          content: Text(
                              "Please wait patiently as your request is still under review by admin."),
                          actions: [
                            TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side: BorderSide(color: Colors.red),
                                  ),
                                ))),
                          ],
                        );
                      },
                    );
                  }
                  if (status == true || status == false) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => track(uid: uid)));
                  }
                },
                icon: Icon(Icons.assignment_ind_rounded, size: 18),
                label: Text(" TRACK REQUEST"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.red)))),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Container(
              height: h / 15,
              width: w / 2,
              child: OutlinedButton.icon(
                  onPressed: () {
                    AuthController.instance.logOut();
                    // Respond to button press
                  },
                  icon: Icon(Icons.logout, size: 18),
                  label: Text("Sign Out"),
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            side: BorderSide(color: Colors.red))),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
