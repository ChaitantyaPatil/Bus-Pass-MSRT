import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:mega_project/home_page.dart';
import 'package:mega_project/new_pass_page2.dart';
import 'lists.dart';
import 'package:mega_project/new_pass_page.dart';
import 'auth_controller.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:image_picker/image_picker.dart';
import 'singup_page.dart';
import 'package:path/path.dart';

class Newpass3 extends StatefulWidget {
  final String userId;
  const Newpass3({super.key, required this.userId});

  @override
  State<Newpass3> createState() => _Newpass3State();
}

class _Newpass3State extends State<Newpass3> {
  late TextEditingController fromvillage = TextEditingController();
  late TextEditingController tovillage = TextEditingController();
  final formkey2 = GlobalKey<FormState>();

  Future uploadTrack() async {
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('Info').doc(widget.userId);
    var fromVillage1 = fromvillage.text.trim();
    var toVillage2 = tovillage.text.trim();
  showDialog(
      context: this.context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          title: Text('Request submitted'),
          content: Text('Your request has been submitted successfully.'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(this.context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        homePage(email: '',)));
              },
            ),
          ],
        );
      },
    );
   


// Update the document with the image URLs
    await userDocRef.update({
      'Source': fromVillage1,
      'Destination': toVillage2,
    });
  }

  Future<List<String>> getVillageList(String query) async {
    List<String> data = villages;

    return await Future.delayed(const Duration(seconds: 1), () {
      return data.where((e) {
        return e.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Select Path')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              const SizedBox(height: 15),
              CustomDropdown.searchRequest(
                fieldSuffixIcon: const Icon(
                  Icons.transfer_within_a_station_rounded,
                  size: 25,
                ),
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                futureRequest: getVillageList,
                hintText: 'From',
                controller: fromvillage,
              ),
              const SizedBox(height: 25),
              CustomDropdown.searchRequest(
                fieldSuffixIcon: const Icon(Icons.train, size: 25),
                borderSide: const BorderSide(color: Colors.grey),
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                futureRequest: getVillageList,
                hintText: 'To',
                controller: tovillage,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    width: 170,
                    child: OutlinedButton.icon(
                        onPressed: () {
                          // AuthController.instance.logOut();
                          // Respond to button press
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Newpass2(
                                    userId: '',
                                  )));
                        },
                        icon: const Icon(Icons.keyboard_backspace_rounded,
                            size: 30),
                        label: const Text("back"),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.red),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side:
                                          const BorderSide(color: Colors.red))),
                        )),
                  ),
                  SizedBox(
                    height: 50,
                    width: 170,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: ElevatedButton.icon(
                          onPressed: () {
                            // Respond to button press
                            if (fromvillage.selection.isValid &&
                                tovillage.selection.isValid) {
                              uploadTrack();
                            } else {
                              ScaffoldMessenger.of(context)
                                  // ignore: prefer_const_constructors
                                  .showSnackBar(SnackBar(
                                content: const Text('Select Path'),
                              ));
                            }
                          },
                          icon: const Icon(Icons.upload_file_rounded, size: 25),
                          label: const Text("Submit"),
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: const BorderSide(color: Colors.red)),
                              ))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
