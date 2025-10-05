import 'package:flutter/material.dart';
import 'package:productive_360_app/data/auth_service.dart';
import 'package:productive_360_app/data/notifiers.dart';
import 'package:productive_360_app/models/habit.dart';
import 'package:productive_360_app/views/widgets/ms_login.dart';

import '../../data/dal/db_access.dart';

// ✅ Add supported Outlook/Windows time zones
const List<String> supportedOutlookTimeZones = [
  "UTC",
  "W. Europe Standard Time", // Vienna, Berlin, Rome
  "GMT Standard Time", // London
  "Eastern Standard Time", // US East
  "Central Standard Time", // US Central
  "Mountain Standard Time", // US Mountain
  "Pacific Standard Time", // US West
  "India Standard Time", // India
  "China Standard Time", // China
  "Tokyo Standard Time", // Japan
  "AUS Eastern Standard Time", // Sydney/Melbourne
];

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Settings Page',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.person),
                    ),
                    Padding(padding: const EdgeInsets.all(8.0)),
                    Text(AuthService().currentUser?.email ?? 'No user email'),
                  ],
                ),
              ),
              Divider(),

              const SizedBox(height: 10),
              Text(
                'Theme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: isDarkModeNotifier,
                builder: (context, isDark, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => isDarkModeNotifier.value = false,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: !isDark
                                  ? Color(0xFF23243B).withOpacity(0.05)
                                  : Colors.transparent,
                              border: Border.all(
                                color: !isDark
                                    ? Color(0xFF4F5DFF)
                                    : Colors.grey.shade700,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.wb_sunny_outlined,
                                  color: !isDark
                                      ? Color(0xFF4F5DFF)
                                      : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Light',
                                  style: TextStyle(
                                    color: !isDark
                                        ? Color(0xFF4F5DFF)
                                        : Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => isDarkModeNotifier.value = true,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Color(0xFF4F5DFF)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isDark
                                    ? Color(0xFF4F5DFF)
                                    : Colors.grey.shade700,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.nightlight_round,
                                  color: isDark ? Colors.white : Colors.grey,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Dark',
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    if (isDark)
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              Divider(),

              // ✅ Add Time Zone selection
              const SizedBox(height: 10),
              Text(
                'Time Zone',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ValueListenableBuilder<String>(
                valueListenable: selectedTimezoneNotifier,
                builder: (context, selectedTz, _) {
                  return DropdownButtonFormField<String>(
                    value: supportedOutlookTimeZones.contains(selectedTz)
                        ? selectedTz
                        : "UTC",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    items: supportedOutlookTimeZones
                        .map(
                          (tz) => DropdownMenuItem(value: tz, child: Text(tz)),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedTimezoneNotifier.value = value;
                      }
                    },
                  );
                },
              ),

              Divider(),
              ValueListenableBuilder(
                valueListenable: isLoggedInNotifier,
                builder: (context, isLoggedIn, child) {
                  return MicrosoftSignInButton();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
