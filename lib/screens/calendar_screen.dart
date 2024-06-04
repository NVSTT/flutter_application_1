import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final Map<DateTime, List<dynamic>> _events;
  late final ValueNotifier<List<dynamic>> _selectedEvents;
  late final TextEditingController _eventController;
  late final CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late List<Map<String, dynamic>> _checklists;

  _CalendarScreenState() {
    _checklists = [];
  }

  @override
  void initState() {
    super.initState();
    _events = {}; // Список событий по датам
    _selectedEvents = ValueNotifier(_getEventsForDay(DateTime.now()));
    _eventController = TextEditingController();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.utc(2024, 5, 1); // Обновленная инициализация
    _selectedDay = DateTime.now();
    _loadChecklists();
  }

  Future<void> _loadChecklists() async {
    try {
      final List<Map<String, dynamic>> checklists = await DBHelper.getChecklists();
      print('Loaded checklists: $checklists');
      setState(() {
        _checklists = checklists;
      });
    } catch (e) {
      print('Failed to load checklists: $e');
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    final List<dynamic> events = [];
    for (final checklist in _checklists) {
      final DateTime checklistDate = DateTime.parse(checklist['id']);
      if (isSameDay(checklistDate, day) && checklist['isCompleted'] == 0) {
        events.add(checklist);
      }
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.grey[800], // серый фон
          padding: const EdgeInsets.all(8.0),
          child: const Center(
            child: Text(
              'Календарный план',
              style: TextStyle(color: Colors.white), // белый текст
            ),
          ),
        ),
        backgroundColor: Colors.grey[800], // делаем AppBar темно-серым
        elevation: 0, // убираем тень
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2024, 5, 1),
            lastDay: DateTime.utc(2024, 5, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedEvents.value = _getEventsForDay(selectedDay);
              });
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder<List<dynamic>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(value[index].toString()),
                      // Здесь можно отобразить другие детали задачи
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _eventController.dispose();
    super.dispose();
  }
}
