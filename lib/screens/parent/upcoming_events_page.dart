import 'package:communication_book/screens/parent/event_details_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          //debugPrint('Event: ${doc['name']}, Date: $date');
          if (_events.containsKey(date)) {
            _events[date]!.add(doc['name']);
          } else {
            _events[date] = [doc['name']];
          }
        });

        _onDaySelected(_selectedDay, _focusedDay);
      });
    } catch (e) {
      debugPrint('Error fetching events: $e');
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
      //debugPrint('Selected events: $_selectedEvents');
    });
  }

Future<String> _getEventDetails(DateTime date, String eventName) async {
  String eventDetails = '';

  try {
    // Format the date to match the format stored in Firestore
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    debugPrint('Date: $formattedDate, Event Name: $eventName');

    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('date', isEqualTo: formattedDate) // Use formatted date for comparison
        .where('name', isEqualTo: eventName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      debugPrint('Query Snapshot: $querySnapshot');
      eventDetails = querySnapshot.docs.first['detail'] ?? ''; // Replace 'event detail' with the actual field name
    }
  } catch (e) {
    debugPrint('Error fetching event details: $e');
    // Handle error
  }

  return eventDetails;
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
                      return GestureDetector(
                        onTap: () async {
                          String eventDetails = await _getEventDetails(
                              _selectedDay, _selectedEvents[index]);
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailsPage(
                                date: _selectedDay,
                                eventName: _selectedEvents[index],
                                eventDetails: eventDetails,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          child: ListTile(
                            leading: const Icon(Icons.event),
                            title: Text(_selectedEvents[index]),
                          ),
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
