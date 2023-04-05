// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, use_key_in_widget_constructors, unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_project/home_page.dart';
import 'package:mega_project/new_pass_page2.dart';
import 'login_page.dart';
import 'package:intl/intl.dart';
import 'lists.dart';
import 'dart:ui' as ui;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Newpass extends StatefulWidget {
  String email;
  Newpass({required this.email});
  @override
  State<Newpass> createState() => _NewpassState();
}

TextEditingController dateController = TextEditingController();
TextEditingController nameController = TextEditingController();
TextEditingController educationController = TextEditingController();
TextEditingController mobileController = TextEditingController();
TextEditingController addressController = TextEditingController();
TextEditingController schoolnameController = TextEditingController();
TextEditingController schooladdressController = TextEditingController();
TextEditingController aadharController = TextEditingController();
var profession = 'Student';
var education = 'Education';

class _NewpassState extends State<Newpass> {
  // const WelcomePage({Key? key}) : super(key: key);
  final formkey = GlobalKey<FormState>();
  String imageUrl = "";
  String bonafideUrl = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic> userData = {
    'name': nameController,
    'dob': dateController,
    'mobile': mobileController,
    'address': addressController,
    'schoolname': schoolnameController,
    'schooladdress': schooladdressController,
    'aadhar': aadharController,
    'userId': '',
  };

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    const snackBar = SnackBar(
      content: Text('not selected date'),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(title: Text('Application Form')),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    controller: nameController,
                    maxLines: null,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 14.0, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.account_circle,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                        return "Enter Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              Center(
                child: Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, top: 15, bottom: 15),
                      child: SizedBox(
                        width: 157,
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          controller: dateController,
                          decoration: const InputDecoration(
                              labelText: "DOB",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.calendar_month_rounded)),
                          readOnly: true,
                          onTap: (() async {
                            DateTime? pickeddate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101),
                            );

                            if (pickeddate != null) {
                              String formateddate =
                                  DateFormat("yyyy-MM-dd").format(pickeddate);

                              setState(() {
                                dateController.text = formateddate.toString();
                              });
                            } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text('Date not selected'),
                              ));
                            }
                          }),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Date of Birth";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, top: 15, bottom: 15),
                      child: SizedBox(
                        width: 203,
                        child: DropdownButtonFormField2(
                          isExpanded: true,
                          hint: Text('-- Profession --'),
                          validator: (value) {
                            if (value != null) {
                              return null;
                            } else {
                              return 'Select Profession';
                            }
                          },
                          //value: dropdownvalue,
                          decoration: InputDecoration(
                            isDense: true,
                            //prefixIcon: Icon(Icons.cast_for_education_rounded),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              //<-- SEE HERE
                              borderSide:
                                  BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          icon: Icon(Icons.keyboard_arrow_down),
                          dropdownDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          //value: profession,
                          onChanged: (value) {
                            setState(() {
                              profession = value!;
                            });
                          },
                          items: <String>['Student', 'Employee']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    controller: mobileController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 14.0, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Mobile No.',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.phone_android,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 10) {
                        return "Enter Valid Mobile Number";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    controller: addressController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                        fontSize: 14.0, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.home,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Address";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    controller: aadharController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 14.0, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Adhaar No.',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.fingerprint_rounded,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length != 12) {
                        return "Enter Valid Aadhaar Number";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                width: 370,
                child: DropdownButtonFormField2(
                  isExpanded: true,
                  hint: Text(
                    '---- Education ----',
                    textAlign: TextAlign.left,
                  ),
                  validator: (value) {
                    if (value != null) {
                      return null;
                    } else {
                      return 'Select Education';
                    }
                  },
                  //value: dropdownvalue,
                  decoration: InputDecoration(
                    isDense: true,
                    //prefixIcon: Icon(Icons.cast_for_education_rounded),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      //<-- SEE HERE
                      borderSide: BorderSide(color: Colors.red, width: 2),
                    ),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down),
                  dropdownDecoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  items: items.map((String items) {
                    return DropdownMenuItem(
                      value: items,
                      child: Text(items),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      education = newValue!;
                    });
                  },
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    controller: schoolnameController,
                    maxLines: null,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        fontSize: 14.0, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'School / Office Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.school,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter School / Office Name";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: SizedBox(
                  width: 370,
                  child: TextFormField(
                    controller: schooladdressController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(
                        fontSize: 14.0, height: 1, color: Colors.black),
                    decoration: InputDecoration(
                      labelText: 'School / office Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(
                        Icons.location_city,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter School / Office Address";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
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
                                builder: (context) => homePage(
                                      email: '',
                                    )));
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
                            onPressed: () async {
                              // Respond to button press
                              var name = nameController.text.trim();
                              var mobile = mobileController.text.trim();
                              var address = addressController.text.trim();
                              var schoolname = schoolnameController.text.trim();
                              var schooladdress =
                                  schooladdressController.text.trim();
                              var aadhar = aadharController.text.trim();
                              var dob = dateController.text.trim();
                              final futureDate = DateTime.now();
                              final now = DateTime.now();
                              if (profession == 'Employee') {
                                final futureDate = now.add(Duration(days: 89));
                              } else {
                                final futureDate = now.add(Duration(days: 29));
                              }
                              final now2 =
                                  DateTime.now().toString().substring(0, 10);

// Format the future date as per your requirement (for example, yyyy-mm-dd)
                              final formattedDate =
                                  "${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}";
                              final User? user = _auth.currentUser;
                              final uid = user?.uid;

                              if (formkey.currentState!.validate() &&
                                  name != "" &&
                                  mobile != "" &&
                                  address != "" &&
                                  schoolname != "" &&
                                  schooladdress != "" &&
                                  aadhar != "") {
                                DocumentReference docRef = FirebaseFirestore
                                    .instance
                                    .collection('Info')
                                    .doc(uid);

                                try {
                                  await docRef.set({
                                    "uid": uid,
                                    "Name": name,
                                    "Mobile": mobile,
                                    "Address": address,
                                    "profession": profession,
                                    "School Name": schoolname,
                                    "School Address": schooladdress,
                                    "Aadhar Number": aadhar,
                                    "Date of birth": dob,
                                    "Email": widget.email,
                                    "Education": education,
                                    "Pass Applied Date": now2,
                                    "Pass Ending Date": formattedDate,
                                    "Payment Status": false,
                                    "approved": '',

                                    // add the auto-generated document ID as a field
                                  }, SetOptions(merge: true));
                                } catch (e) {
                                  print("Error $e");
                                }
                                String userId = docRef.id;

                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Newpass2(userId: userId)));

                                nameController.clear();
                                mobileController.clear();
                                addressController.clear();
                                schoolnameController.clear();
                                schooladdressController.clear();
                                aadharController.clear();
                                dateController.clear();
                              } else {
                                print("Info Not saved");
                              }
                            },
                            icon: Icon(Icons.arrow_back_rounded, size: 25),
                            label: Text("Next"),
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
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
