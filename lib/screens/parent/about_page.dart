import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }

  Future<void> _launchEmail(String email) async {
    if (await canLaunch("mailto:$email")) {
      await launch("mailto:$email");
    } else {
      throw 'Could not launch';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Alliance Academy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18.0, right: 18, top: 23),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(
                color: Color(0xFF750F21),
                fontWeight: FontWeight.w900,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Lorem Ipsum is simply dummy text of the printing'
              ' and typesetting industry. Lorem Ipsum has been the'
              ' industry\'s standard dummy text ever since the 1500s, '
              'when an unknown printer took a galley of type and scrambled'
              ' it to make a type specimen book. It has survived not only five'
              ' it to make a type specimen book. It has survived not only five'
              'when an unknown printer took a galley of type and scrambled'
              ' centuries, but also the leap into electronic typesetting, remaining'
              ' essentially unchanged. It was popularised in the 1960s with the release'
              ' of Letraset sheets containing Lorem Ipsum passages, and more recently'
              ' with desktop publishing software like Aldus PageMaker'
              ' including versions of Lorem Ipsum.',
              style: TextStyle(
                color:  Colors.grey.shade700,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Contact Us',
              style: TextStyle(
                color:  Color(0xFF750F21),
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                _makePhoneCall('+251930884402');
              },
              child: ListTile(
                tileColor:  Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: const Text(
                  'Phone No',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('+251930884402'),
                trailing: const Icon(
                  Icons.phone,
                  color: Color(0xFF750F21),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                _launchEmail('edilayehu534027@gmail.com');
              },
              child: ListTile(
                tileColor:  Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: const Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: const Text('edilayehu534027@gmail.com'),
                trailing: const Icon(
                  Icons.mail_outline,
                  color: Color(0xFF750F21),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
