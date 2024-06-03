import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Календарный план'),
      ),
      body: Center(
        child: Text('Календарный план на Март 2024'),
      ),
    );
  }
}
