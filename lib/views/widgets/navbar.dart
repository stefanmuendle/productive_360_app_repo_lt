import 'package:flutter/material.dart';
import 'package:productive_360_app/data/notifiers.dart';

class NavbarWidget extends StatelessWidget {
  final bool inAppBar;
  const NavbarWidget({super.key, this.inAppBar = false});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedPageNotifier,
      builder: (context, selectedPage, child) {
        if (inAppBar) {
          // Use horizontal buttons with labels, aligned right
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: Icon(
                  Icons.dashboard,
                  color: selectedPage == 0 ? Colors.blue : Colors.grey,
                ),
                label: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: selectedPage == 0 ? Colors.blue : Colors.grey,
                  ),
                ),
                onPressed: () => selectedPageNotifier.value = 0,
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.calendar_today,
                  color: selectedPage == 1 ? Colors.blue : Colors.grey,
                ),
                label: Text(
                  'Calendar',
                  style: TextStyle(
                    color: selectedPage == 1 ? Colors.blue : Colors.grey,
                  ),
                ),
                onPressed: () => selectedPageNotifier.value = 1,
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.check_circle,
                  color: selectedPage == 2 ? Colors.blue : Colors.grey,
                ),
                label: Text(
                  'Habits',
                  style: TextStyle(
                    color: selectedPage == 2 ? Colors.blue : Colors.grey,
                  ),
                ),
                onPressed: () => selectedPageNotifier.value = 2,
              ),
            ],
          );
        } else {
          // Use NavigationBar for bottom nav
          return NavigationBar(
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today),
                label: 'Calendar',
              ),
              NavigationDestination(
                icon: Icon(Icons.check_circle),
                label: 'Habits',
              ),
            ],
            onDestinationSelected: (value) {
              selectedPageNotifier.value = value;
            },
            selectedIndex: selectedPage,
          );
        }
      },
    );
  }
}
