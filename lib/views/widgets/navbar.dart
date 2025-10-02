import 'package:flutter/material.dart';
import 'package:productive_360_app/data/notifiers.dart';


class NavbarWidget extends StatelessWidget {
  const NavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, builder: (context, selectedPage, child) {
      return NavigationBar(destinations: [
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          NavigationDestination(icon: Icon(Icons.check_circle), label: 'Habits'),
        ],

        onDestinationSelected: (value) {
          selectedPageNotifier.value = value; 
        },
        selectedIndex: selectedPage,
      );

    },);
  }
}