import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:toast/toast.dart';

import 'home_page.dart';

class Payment extends StatefulWidget {
  final String uid;
  const Payment({required this.uid, Key? key}) : super(key: key);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  int _counter = 0;
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    'Make a Payment',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
  ),
  centerTitle: true,
  
  backgroundColor: Colors.red,
),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Info')
            .doc(widget.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (!snapshot.hasData) {
            return Text('Loading...');
          }

          final payableAmount = snapshot.data!.get('paymentAmount');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,),
                Text(
                  '      Choose a Payment Method : ',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Razorpay razorpay = Razorpay();
                        var options = {
                          'key': 'rzp_test_NNbwJ9tmM0fbxj',
                          'amount': payableAmount * 100,
                          'name': 'Payment',
                          'description': 'Payment for bus pass',
                          'prefill': {
                            'contact': '9999999999',
                            'email': 'test@acme.com'
                          },
                          'external': {
                            'wallets': ['paytm']
                          },
                        };
                        razorpay.on(
                          Razorpay.EVENT_PAYMENT_ERROR,
                          handlePaymentErrorResponse,
                        );
                        razorpay.on(
                          Razorpay.EVENT_PAYMENT_SUCCESS,
                          handlePaymentSuccessResponse,
                        );
                        razorpay.on(
                          Razorpay.EVENT_EXTERNAL_WALLET,
                          handleExternalWalletSelected,
                        );
                        razorpay.open(options);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.payment_rounded, size: 20),
                          SizedBox(width: 5),
                          Text('Pay with Razorpay'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          );
        },
      ),
    );
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    showAlertDialog(context, "Payment Failed",
        "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
    final paymentId = response.paymentId;

    // Store payment ID to Firebase
    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore
        .collection('Info')
        .where('uid', isEqualTo: widget.uid)
        .get()
        .then((QuerySnapshot snapshot) async {
      // Get the first document returned by the query
      DocumentSnapshot documentSnapshot = snapshot.docs.first;

      // Get the reference to the document
      DocumentReference docRef = documentSnapshot.reference;

      // Update the document
      final now = DateTime.now();
      final futureDate = now.add(Duration(days: 29));
      final now2 = DateTime.now().toString().substring(0, 10);
      final formattedDate =
          "${futureDate.year}-${futureDate.month.toString().padLeft(2, '0')}-${futureDate.day.toString().padLeft(2, '0')}";
      await docRef.update({
        'Payment Id': paymentId,
        'Payment Status': true,
        "Pass Applied Date": now2,
        "Pass Ending Date": formattedDate,
      });
    }).catchError((error) {
      print('Failed to update document: $error');
    });

    showAlertDialog(
        context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    showAlertDialog(
        context, "External Wallet Selected", "${response.walletName}");
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => homePage(
                  email: '',
                )));
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
