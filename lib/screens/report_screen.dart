import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';


class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> checklists = [];
  List<Map<String, dynamic>> tasks = [];
  String? selectedChecklistId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    checklists = await DBHelper.getChecklists();
    setState(() {});
  }

  Future<void> _loadTasks() async {
    if (selectedChecklistId != null) {
      tasks = await DBHelper.getChecklistItems(selectedChecklistId!);
      setState(() {});
    }
  }
  
  Future<void> _createPDF() async {
  if (selectedChecklistId == null) {
    // Не выбран чек-лист, показать сообщение или вернуться назад
    return;
  }

  await _loadTasks();

  final pdf = pdfLib.Document();

  tasks = await DBHelper.getChecklistItems(selectedChecklistId!);

  // Создаем страницы документа
  for (var checklist in checklists) {
    final List<Map<String, dynamic>> tasksForChecklist = tasks.where((task) => task['checklistId'] == checklist['id']).toList();

    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.Text('Чек-лист: ${checklist['title']}'),
              for (var task in tasksForChecklist)
                pdfLib.Column(
                  crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                  children: [
                    pdfLib.Text('Задача: ${task['description']}'),
                    pdfLib.Text('Исполнитель: ${task['executor']}'),
                    pdfLib.Text('Статус: ${task['status'] == 1 ? 'Выполнено' : 'В процессе'}'),
                    pdfLib.Text('-----------------------------------'),
                  ],
                ),
              pdfLib.Text('-----------------------------------'),
            ],
          );
        },
      ),
    );
  }

  // Получаем путь для сохранения PDF-файла
  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/report.pdf';
  final File file = File(path);

  // Записываем созданный PDF-документ в файл
  await file.writeAsBytes(await pdf.save());

}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Container(
        color: Colors.grey[800], // серый фон
        padding: const EdgeInsets.all(8.0), 
        child: const Center(
          child: Text('Отчетность',
            style: TextStyle(color: Colors.white), // белый текст
          ),
        ),
      ),
      backgroundColor: Colors.grey[800], // делаем AppBar темно-серым
      elevation: 0, // убираем тень
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (checklists.isEmpty)
            CircularProgressIndicator()
          else
            DropdownButton<String>(
              value: selectedChecklistId,
              items: checklists.map((Map<String, dynamic> checklist) {
                return DropdownMenuItem<String>(
                  value: checklist['id'].toString(),
                  child: Text(checklist['title']),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  selectedChecklistId = value;
                  _loadTasks();  // Загрузить задачи при выборе чек-листа
                });
              },
            ),
          ElevatedButton(
            onPressed: _createPDF,
            child: const Text('Создать PDF'),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: tasks.length,  // Использовать количество задач вместо количества чек-листов
                itemBuilder: (context, index) {
                  final task = tasks[index];  // Получить задачу вместо чек-листа
                  return ListTile(
                    title: Text('Задача: ${task['description']}'),
                    subtitle: Text('Исполнитель: ${task['executor']}\nСтатус: ${task['status'] == 1 ? 'Выполнено' : 'В процессе'}'),
                  );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
}
