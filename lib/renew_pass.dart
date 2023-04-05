//ignore_for_file: prefer_const_constructors
//ignore_for_file: Prefer const literals as parameters of constructors on @immutable classes
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

import 'package:mega_project/home_page.dart';
import 'package:mega_project/new_pass_page.dart';
import 'package:http/http.dart' as http;
import 'package:mega_project/payment.dart';
import 'package:mega_project/track.dart';

class Renewpass extends StatefulWidget {
  final String uid;
  Renewpass({super.key,required this.uid});
  

  @override
  State<Renewpass> createState() => _RenewpassState();
}

class _RenewpassState extends State<Renewpass> {
  final TextEditingController adhaarNoController = TextEditingController();
  Map<String, dynamic> userMap = {};
  Widget _imageWidget = Container();
  

  void showData() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('Info')
        .where('uid', isEqualTo: widget.uid)
        .get()
        .then((value) async {
      setState(() {
        userMap = value.docs[0].data();
        
      });
      
      final imageUrl = userMap['imageUrl'];
      if (imageUrl != null) {
        final response = await http.get(Uri.parse(imageUrl));
        final bytes = response.bodyBytes;
        setState(() {
          _imageWidget = Image.memory(bytes);
        });
      }
    });
    aadharController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Renew Pass')),
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: [
              SizedBox(height: 15),
              Row(
                children: [
                  Text("      Your previous information :",style: TextStyle(fontSize: 16)),
                ],
              ),
              SizedBox(height: 15),
              Container(
                width: 350,
                height: 310,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(
                        7.0, // Move to right 7.0 horizontally
                        8.0, // Move to bottom 8.0 Vertically
                      ),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name : ${userMap['Name']}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text('Date of Birth : ${userMap['Date of birth']}',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      /*Text('Pass Applied Date: ${userMap['Pass Applied Date']}',
                          style: TextStyle(fontSize: 16)),*/
                    
                          SizedBox(height: 5),
                      Text('Source : ${userMap['Source']}',
                          style: TextStyle(fontSize: 16)),
                          SizedBox(height: 5),
                      Text('Destination : ${userMap['Destination']}',
                          style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                      Text('Old Pass Details :',
                          style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 5),
                      Text('Staring Date : ${userMap['Pass Applied Date']}',
                          style: TextStyle(fontSize: 16,
                          color: Colors.red)),
                      Text('Ending Date : ${userMap['Pass Ending Date']}',
                          style: TextStyle(fontSize: 16,
                          color: Colors.red)),
                           SizedBox(height: 10),
                           Text('New Pass Details :',
                          style: TextStyle(fontSize: 16)),
                      SizedBox(height: 5),
                      Text(
                          'Staring Date : ${DateFormat('dd-MMM-yyyy').format(DateTime.now())}',
                          style: TextStyle(fontSize: 16, color: Colors.green)),
                      Text(
                          'Ending Date : ${DateFormat('dd-MMM-yyyy').format(DateTime.now().add(Duration(days: 29)))}',
                          style: TextStyle(fontSize: 16, color: Colors.green)),
                          SizedBox(height: 20,),
                          Text(
                        ' Renewal Charges :  ${userMap['paymentAmount']}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 50,
                      width: 170,
                      child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => homePage(email: '',)));
                            // Respond to button press
                          },
                          icon: Icon(Icons.home, size: 18),
                          label: Text("Home"),
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.red))),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 50,
                      width: 170,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: ElevatedButton.icon(
                            onPressed: showData,
                            icon: Icon(Icons.get_app_rounded, size: 25),
                            label: Text("Get"),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      side: BorderSide(color: Colors.red)),
                                ))),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 380,
                height: 50,
                child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Payment(uid: uid)),
                          );
                    },
                    icon: const Icon(Icons.payment_rounded, size: 25),
                    label: const Text("Pay"),
                    style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                              side: const BorderSide(color: Colors.red)),
                        ))),
              ),
            ])));
  }
}
