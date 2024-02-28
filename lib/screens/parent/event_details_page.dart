import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventDetailsPage extends StatelessWidget {
  final DateTime date;
  final String eventName;
  final String eventDetails; // Add event details field

  const EventDetailsPage(
      {super.key,
      required this.date,
      required this.eventName,
      required this.eventDetails});

  @override
  Widget build(BuildContext context) {
    // Format the date in YYYY-MM-DD format
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          eventName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, top: 25, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Date: $formattedDate', // Display formatted date
              style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Text(
            //   'Event Name: $eventName',
            //   style: const TextStyle(fontSize: 18),
            // ),
            // const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                eventDetails, // Display event details
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
