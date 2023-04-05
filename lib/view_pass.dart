import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mega_project/track.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
class ViewPassPage extends StatefulWidget {
  final String uid;

  ViewPassPage({Key? key, required this.uid}) : super(key: key);

  @override
  _ViewPassPageState createState() => _ViewPassPageState();
}
class ClickEvent {
  final String text;
  final DateTime time;

  ClickEvent({required this.text, required this.time});
}
class _ViewPassPageState extends State<ViewPassPage> {
 
  late SharedPreferences _prefs;
  int _pressCount = 0;
  bool _buttonEnabled = true;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    _resetPressCountAtMidnight();
  }

  void _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _pressCount = _prefs.getInt('pressCount') ?? 0;
    setState(() {
      _buttonEnabled = _pressCount < 2;
    });
  }

  void _resetPressCountAtMidnight() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      DateTime now = DateTime.now();
      DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
      Duration timeUntilMidnight = tomorrow.difference(now);
      if (timeUntilMidnight.inMinutes == 0) {
        _prefs.setInt('pressCount', 0);
        setState(() {
          _pressCount = 0;
          _buttonEnabled = true;
        });
      }
    });
  }

  void _onButtonPressed() async {
     DateTime now = DateTime.now();
    await _firestore
        .collection('Info')
        .where('uid', isEqualTo: widget.uid)
        .get()
        .then((value) async {
      setState(() {
        userMap = value.docs[0].data();
      });
    });

    if (_dateColor == Colors.green) {
      setState(() {
        _dateColor = Colors.yellow;
        _clickText = 'Going To ${userMap['Destination']}';
        _clickedTime = now;
      });
    } else if (_dateColor == Colors.yellow) {
      setState(() {
        _dateColor = Colors.red;
        _clickText = 'Going To ${userMap['Source']}';
        _clickedTime = now;
        _isButtonDisabled = true;
      });
    }
    _pressCount++;
    await _prefs.setInt('pressCount', _pressCount);
    setState(() {
      _buttonEnabled = _pressCount < 2;
    });
  }


  Color _dateColor = Colors.green; // initial color
  String _clickText = '';
  String _clickTime = '';
  DateTime? _clickedTime;
  bool _isButtonDisabled = false;

  bool isWithinRange(DateTime date, DateTime rangeStart, DateTime rangeEnd) {
    return date.isAfter(rangeStart.subtract(Duration(days: 1))) &&
        date.isBefore(rangeEnd.add(Duration(days: 1)));
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> userMap = {};

  Future<void> _handleButtonClick() async {
   
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('My Pass'),
    ),
    body: StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Info')
          .doc(uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData) {
          return Text('Loading...');
        }

       final startString = snapshot.data!.get('Pass Applied Date');
          final endString = snapshot.data!.get('Pass Ending Date');

          final _startDate = DateTime.parse(startString);
          final _endDate = DateTime.parse(endString);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TableCalendar(
                firstDay: _startDate,
                lastDay: _endDate,
                focusedDay: DateTime.now(),
                selectedDayPredicate: (day) {
                  return isWithinRange(day, _startDate, _endDate);
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: _dateColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              if (_clickedTime != null)
                Text(
                  '$_clickText on ${_clickedTime!.day}/${_clickedTime!.month}/${_clickedTime!.year} at ${_clickedTime!.hour}:${_clickedTime!.minute}',
                  style: TextStyle(fontSize: 18.0),
                ),
              SizedBox(height: 20.0),
              Container(
                height: 60,
                width: 180,
                child: ElevatedButton.icon(
                  onPressed: //_isButtonDisabled ? null : _handleButtonClick,
                    _buttonEnabled ? _onButtonPressed : null,
                  icon: Icon(Icons.check_box_rounded, size: 20),
                  label: Text("Mark today"),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: Color.fromARGB(255, 139, 136, 136),
                        ),
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

       
       }
