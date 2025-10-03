import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:productive_360_app/data/notifiers.dart';
import 'package:productive_360_app/views/pages/dashboard_page.dart';
import 'package:productive_360_app/views/pages/login_page.dart';
import 'pages/calendar_page.dart';
import 'pages/habits_page.dart';
import 'pages/settings_page.dart';
import 'widgets/navbar.dart';

List<Widget> pages = [DashboardPage(), CalendarPage(), HabitsPage()];

class WidgetTree extends StatelessWidget {
  const WidgetTree({super.key});

  bool _isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool isWebOrTablet = kIsWeb || _isWideScreen(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.monitor_heart_sharp, color: Colors.blue, size: 38),
            const SizedBox(width: 6),
            const Text(
              'P360',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
          ],
        ),
        actions: [
          if (isWebOrTablet) NavbarWidget(inAppBar: true), // <-- Add here!
          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user == null) {
                return TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(title: 'Login'),
                      ),
                    );
                  },
                  child: Text('Login'),
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.logout, color: Colors.red),
                  tooltip: 'Logout',
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.star, color: Colors.amber),
            onPressed: () {
              // TODO: Add star action
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: selectedPageNotifier,
        builder: (context, selectedPage, child) {
          return pages.elementAt(selectedPage);
        },
      ),
      bottomNavigationBar: isWebOrTablet ? null : const NavbarWidget(),
    );
  }
}
