// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class CalendarPage extends StatefulWidget {
//   const CalendarPage({Key? key}) : super(key: key);

//   @override
//   _CalendarPageState createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   late Map<DateTime, List<dynamic>> _events;
//   late List<dynamic> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime _selectedDay = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _events = {};
//     _selectedEvents = [];
//     _fetchEvents();
//   }

// Future<void> _fetchEvents() async {
//   try {
//     QuerySnapshot<Map<String, dynamic>> eventsQuery =
//         await FirebaseFirestore.instance.collection('events').get();

//     _events = {};
//     eventsQuery.docs.forEach((doc) {
//       final String dateString = doc['date'];
//       final DateTime date = DateTime.parse(dateString);
//       print('Event: ${doc['name']}, Date: $date');
//       if (_events.containsKey(date)) {
//         _events[date]!.add(doc['name']);
//       } else {
//         _events[date] = [doc['name']];
//       }
//     });

//     _onDaySelected(_selectedDay, _focusedDay);
//   } catch (e) {
//     print('Error fetching events: $e');
//     // Handle error here
//   }
// }

// List<dynamic> _getEventsForDay(DateTime day) {
//   final formattedDay = DateTime(day.year, day.month, day.day);
//   return _events[formattedDay] ?? [];
// }

//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     setState(() {
//       _selectedDay = selectedDay;
//       _focusedDay = focusedDay;
//       _selectedEvents = _getEventsForDay(selectedDay);
//       print('Selected events: $_selectedEvents');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Calendar with Events',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           TableCalendar(
//             firstDay: DateTime.utc(2010, 10, 16),
//             lastDay: DateTime.utc(2030, 3, 14),
//             focusedDay: _focusedDay,
//             calendarFormat: _calendarFormat,
//             onFormatChanged: (format) {
//               setState(() {
//                 _calendarFormat = format;
//               });
//             },
//             selectedDayPredicate: (day) {
//               return isSameDay(_selectedDay, day);
//             },
//             onDaySelected: _onDaySelected,
//             eventLoader: _getEventsForDay,
//           ),
//           Expanded(
//             child: _selectedEvents.isNotEmpty
//                 ? ListView.builder(
//                     itemCount: _selectedEvents.length,
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     itemBuilder: (BuildContext context, int index) {
//                       return Card(
//                         child: ListTile(
//                           title: Text(_selectedEvents[index]),
//                         ),
//                       );
//                     },
//                   )
//                 : const Center(
//                     child: Text(
//                       "No events for selected day",
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<dynamic>> _events;
  late List<dynamic> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _events = {};
    _selectedEvents = [];
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      FirebaseFirestore.instance
          .collection('events')
          .snapshots()
          .listen((event) {
        _events = {};
        event.docs.forEach((doc) {
          final String dateString = doc['date'];
          final DateTime date = DateTime.parse(dateString);
          print('Event: ${doc['name']}, Date: $date');
          if (_events.containsKey(date)) {
            _events[date]!.add(doc['name']);
          } else {
            _events[date] = [doc['name']];
          }
        });

        _onDaySelected(_selectedDay, _focusedDay);
      });
    } catch (e) {
      print('Error fetching events: $e');
      // Handle error here
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final formattedDay = DateTime(day.year, day.month, day.day);
    return _events[formattedDay] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _selectedEvents = _getEventsForDay(selectedDay);
      print('Selected events: $_selectedEvents');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar with Events',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              "Event",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _selectedEvents.isNotEmpty
                ? ListView.builder(
                    itemCount: _selectedEvents.length,
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(_selectedEvents[index]),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No events for selected day",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
