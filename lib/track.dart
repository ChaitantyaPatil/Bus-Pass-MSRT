// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_key_in_widget_constructors, unused_import
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mega_project/home_page.dart';
import 'package:mega_project/payment.dart';

class track extends StatefulWidget {
  final String uid;
  const track({super.key, required this.uid});
  

  @override
  State<track> createState() => _trackState();
}

// Get the current user
final FirebaseAuth _auth = FirebaseAuth.instance;
final User? user = _auth.currentUser;
final uid = user!.uid;
final formkey = GlobalKey<FormState>();

class _trackState extends State<track> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track My Application'),
      ),
      body:SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formkey,
          child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Info')
            .where('uid', isEqualTo: widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            if (documents.isEmpty) {
              return Center(
                child: Text('No applications found.'),
              );
            } else {
              Map<String, dynamic>? requestDetails =
                  documents.first.data() as Map<String, dynamic>?;
              //final bool isApproved = requestDetails['approved'] ?? false;
              final bool status = requestDetails!['approved'];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!status)
                      Column(
                        children: [
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red,
                                  width: 5,
                                ),
                              ),
                              child: Image.asset(
                                'images/reject.png',
                                width: 190,
                                height: 190,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Unfortunately',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red,
                            ),
                          ),
                          const Text(
                            'Your application has been rejected.',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                   
                    if (status)
                      Column(
                        children: [
                          Center(
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green,
                                  width: 5,
                                ),
                              ),
                              child: Image.asset(
                                'images/approved.png',
                                width: 190,
                                height: 190,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Congratulations !!',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.green,
                            ),
                          ),
                          const Text(
                            'Your application has been Approved.',
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.green,
                            ),
                          ),
                          
                        ],
                      ),
                      SizedBox(height: 16.0),
                      Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Image.network(requestDetails['imageUrl']),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Name: ${requestDetails['Name']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Aadhar Number: ${requestDetails['Aadhar Number']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Address: ${requestDetails['Address']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Mobile: ${requestDetails['Mobile']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'School Name: ${requestDetails['School Name']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'School Address: ${requestDetails['School Address']}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Row(
                      children: [
                        Text(
                          'Source: ${requestDetails['Source']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Text(
                          'Destination: ${requestDetails['Destination']}',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Pass Starting Date:   ${DateFormat('dd-MM-yyyy').format(DateTime.parse(requestDetails['Pass Applied Date']))}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Pass Ending Date:     ${DateFormat('dd-MM-yyyy').format(DateTime.parse(requestDetails['Pass Ending Date']))}',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10.0),
                      if (requestDetails['approved']== true && requestDetails['Payment Status'] == false)
                      Text(
                          'Amount To be paid : ${requestDetails['paymentAmount']} ₹',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 15.0),
                      if (requestDetails['approved'] == true &&
                        requestDetails['Payment Status'] == false)
                      Container(
                        height: 45,
                        width: 180,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Payment(
                                          uid: uid,
                                        )),
                              );
                            },
                            icon: Icon(Icons.payment, size: 25),
                            label: Text("Make Payment"),
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
                                      borderRadius: BorderRadius.circular(15),
                                      side: BorderSide(color: Colors.red)),
                                ))),
                      ),
                     if (requestDetails['reason'] != '' && requestDetails['reason'] != null && status== false)
                      Text(
                        '*Reason: ${requestDetails['reason'].toString().replaceAll('[', '').replaceAll(']', '')}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.red,
                        ),
                      ),

                    /**/
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        )),
    ));
  }
}
