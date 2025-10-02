import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:icons_plus/icons_plus.dart';
import 'package:productive_360_app/data/ms_auth_service.dart';
import 'package:productive_360_app/data/notifiers.dart';
import 'package:productive_360_app/data/auth_service.dart';
import 'package:productive_360_app/views/pages/login_page.dart';

class MicrosoftSignInButton extends StatefulWidget {
  const MicrosoftSignInButton({super.key});

  @override
  State<MicrosoftSignInButton> createState() => _MicrosoftSignInButtonState();
}

class _MicrosoftSignInButtonState extends State<MicrosoftSignInButton> {
  final _authService = MicrosoftAuthService();
  final _firebaseAuthService = AuthService();
  String? _userEmail;
  bool _isSignedIn = false;

  Future<void> _fetchUserEmail() async {
    final token = _authService.getMicrosoftAccessToken();
    if (token == null) return;

    final url = Uri.parse(
      "https://graph.microsoft.com/v1.0/me/calendarview?startdatetime=2025-09-09T16:36:39.866Z&enddatetime=2025-09-16T16:36:39.866Z",
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final events = data['value'] as List<dynamic>?;

      if (events != null && events.isNotEmpty) {
        for (final event in events) {
          final eventInfo = {
            "title": event['subject'],
            "start": event['start']?['dateTime'],
            "end": event['end']?['dateTime'],
            "category": event['categories']?.join(', '),
            "isAllDay": event['isAllDay'],
            "description": event['bodyPreview'],
            "location": event['location']?['displayName'],
            "organizer": event['organizer']?['emailAddress']?['name'],
          };
          //print(JsonEncoder.withIndent('  ').convert(eventInfo));
        }
      } else {
        print("No events found in the given timespan.");
      }
    } else {
      print("❌ Failed to fetch calendar events: ${response.body}");
    }
  }

  Future<void> _signIn() async {
    // Check if user is signed in to Firebase
    if (_firebaseAuthService.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must login first to sync with Microsoft.'),
          backgroundColor: Colors.red,
        ),
      );
      // Redirect to login page (replace with your route name)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(title: 'Login'),
        ),
      );
      return;
    }

    try {
      final token = await _authService.signInWithMicrosoft();
      if (token != null) {
        setState(() => _isSignedIn = true);
        isLoggedInNotifier.value = true;
        await _fetchUserEmail();
      }
    } catch (e, st) {
      print("Sign-in error: $e");
      print(st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoggedIn = _isSignedIn;
    final String? email = _userEmail;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoggedIn
                ? Colors.green.withOpacity(0.7)
                : Colors.blue[800],
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 2,
          ),
          icon: isLoggedIn
              ? const Icon(Icons.check_circle, size: 28)
              : const Icon(Bootstrap.microsoft, size: 28, color: Colors.blue),
          label: isLoggedIn
              ? Text(
                  "Logged in: ${email ?? ''}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const Text(
                  "Sync your Microsoft Calendar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
          onPressed: _signIn,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
