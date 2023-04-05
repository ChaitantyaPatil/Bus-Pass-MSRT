// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_key_in_widget_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mega_project/FullScreenImage.dart';

class StudentRequestDetailsScreen extends StatelessWidget {
  final String requestId;

  StudentRequestDetailsScreen({super.key, required this.requestId});
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Request Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Info')
            .doc(requestId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Map<String, dynamic>? requestDetails =
              snapshot.data!.data() as Map<String, dynamic>?;

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        'Name : ${requestDetails!['Name']}',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 100.0),
                      Text(
                        'Date: ${requestDetails['Date of birth']}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Profession: ${requestDetails['profession']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Education: ${requestDetails['Education']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Aadhar Number: ${requestDetails['Aadhar Number']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Address: ${requestDetails['Address']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Mobile: ${requestDetails['Mobile']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'School Name: ${requestDetails['School Name']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'School Address: ${requestDetails['School Address']}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Pass Applied Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(requestDetails['Pass Applied Date']))}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Pass Ending Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(requestDetails['Pass Ending Date']))}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'Source : ${requestDetails['Source']}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 100.0),
                      Text(
                        'Destination : ${requestDetails['Destination']}',
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Documnets :',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  FullScreenImage(requestDetails['imageUrl']),
                            ),
                          );
                        },
                        child: Container(
                          width: 180,
                          height: 240,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Image.network(requestDetails['imageUrl']),
                        ),
                      ),
                      SizedBox(
                        width: 19,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(
                                  requestDetails['bonafideUrl']),
                            ),
                          );
                        },
                        child: Container(
                          width: 180,
                          height: 240,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: Image.network(requestDetails['bonafideUrl']),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // show a dialog to enter the payment amount
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              double? paymentAmount;
                              return AlertDialog(
                                title: Text('Enter Payment Amount'),
                                content: TextFormField(
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter amount',
                                  ),
                                  onChanged: (value) {
                                    paymentAmount = double.tryParse(value);
                                  },
                                ),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: Text('OK'),
                                    onPressed: () async {
                                      // update the 'approved' field to true
                                      await _firestore
                                          .collection('Info')
                                          .doc(requestId)
                                          .update({
                                        'approved': true,
                                        'paymentAmount': paymentAmount
                                      });
                                      Navigator.of(context).pop();
                                      // show a success message
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Request Approved'),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.check),
                            SizedBox(width: 8.0),
                            Text('Approve'),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: 70,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                String dropdownValue = 'Your Documents are not clear';
                                List<String> reasons = [
                                  'Your Documents are not clear',
                                  'Your details are not correct ',
                                  'Your selected route is not allowed',
                                  'Other',
                                ];
                                Set<String> selectedReasons = {};
                                TextEditingController otherReason =
                                    TextEditingController();

                                return AlertDialog(
                                  title: Text('Reason for Rejection'),
                                  content: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DropdownButton<String>(
                                            value: dropdownValue,
                                            icon: const Icon(
                                                Icons.arrow_drop_down),
                                            iconSize: 24,
                                            elevation: 16,
                                            style: const TextStyle(
                                                color: Colors.black),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                dropdownValue = newValue!;
                                              });
                                            },
                                            items: reasons
                                                .map<DropdownMenuItem<String>>(
                                                    (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                          SizedBox(height: 8),
                                          if (dropdownValue == 'Other')
                                            TextField(
                                              controller: otherReason,
                                              decoration: InputDecoration(
                                                  hintText: 'Other reason'),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton(
                                      child: Text('Reject'),
                                      onPressed: () {
                                        String rejectionReason =
                                            dropdownValue == 'Other'
                                                ? otherReason.text
                                                : dropdownValue;
                                        selectedReasons.add(rejectionReason);

                                        _firestore
                                            .collection('Info')
                                            .doc(requestId)
                                            .update({
                                          'approved': false,
                                          'reason': selectedReasons.toList()
                                        });

                                        Navigator.of(context).pop();

                                        // show a success message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text('Request Rejected'),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Row(children: [
                            Icon(Icons.close),
                            SizedBox(width: 8.0),
                            Text('Reject'),
                          ])),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
