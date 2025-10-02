import 'package:flutter/material.dart';

import '../style.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [Text('Dashboard Page', style: KTextStyle.tileTealText)],
      ),
    );
  }
}
