import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import 'package:image_picker/image_picker.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  late TextEditingController _titleController;
  late String? _photoPath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _photoPath = null;
    DBHelper.addTestData();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _photoPath = image.path;
      });
    }
  }

  Future<void> _addChecklist() async {
    if (_titleController.text.isNotEmpty) {
      await DBHelper.addChecklist({
        'id': DateTime.now().toString(),
        'title': _titleController.text,
        'isCompleted': 0,
        'photo': _photoPath ?? '',
      });
      _titleController.clear();
      setState(() {
        _photoPath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          color: Colors.grey[800],
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              'Чек-лист',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        backgroundColor: Colors.grey[800],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Название чек-листа',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(),
              child: Text('Выбрать фото'),
            ),
            SizedBox(height: 20),
            _photoPath == null
                ? Text('Фотография не выбрана.')
                : Image.file(File(_photoPath!)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addChecklist(),
              child: Text('Добавить чек-лист'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: DBHelper.getChecklists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Произошла ошибка!'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (ctx, index) {
                        var checklist = snapshot.data![index];
                        return ListTile(
                          title: Text(checklist['title']),
                          subtitle: Text('Статус: ' +
                              (checklist['isCompleted'] == 1
                                  ? 'Выполнено'
                                  : 'В процессе')),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChecklistDetailScreen(checklist),
                              ),
                            ).then((_) {
                              setState(() {}); // обновляем 
                            });
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChecklistDetailScreen extends StatefulWidget {
  final Map<String, dynamic> checklist;

  ChecklistDetailScreen(this.checklist);

  @override
  _ChecklistDetailScreenState createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  late TextEditingController _taskDescriptionController;
  late TextEditingController _itemNumberController;
  late File? _confirmationPhoto;
  late Future<List<Map<String, dynamic>>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _taskDescriptionController = TextEditingController();
    _itemNumberController = TextEditingController();
    _tasksFuture = DBHelper.getChecklistItemsByChecklistId(widget.checklist['id']);
  }

  Future<void> _pickConfirmationPhoto() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _confirmationPhoto = File(image.path);
      });
    }
  }

  Future<void> _addOrUpdateTask() async {
    final description = _taskDescriptionController.text.trim();
    final itemNumber = int.tryParse(_itemNumberController.text.trim()) ?? 0;
    final confirmationPhoto = _confirmationPhoto?.path ?? '';

    if (description.isNotEmpty && itemNumber > 0) {
      final data = {
        'itemNumber': itemNumber,
        'description': description,
        'isCompleted': 0,
        'confirmationPhoto': confirmationPhoto,
        'checklistId': widget.checklist['id'],
      };

      final isUpdate = _itemNumberController.text.isNotEmpty;

      final Map<String, Object> dataObject = data.map((key, value) => MapEntry(key, value as Object));

      if (isUpdate) {
        await DBHelper.updateChecklistItem(itemNumber, dataObject);
      } else {
        await DBHelper.addChecklistItem(dataObject);
      }

      setState(() {
        _taskDescriptionController.clear();
        _itemNumberController.clear();
        _confirmationPhoto = null;
        _tasksFuture = DBHelper.getChecklistItemsByChecklistId(widget.checklist['id']);
      });
    }
  }

  void _editTask(Map<String, dynamic> task) {
    _itemNumberController.text = task['itemNumber'].toString();
    _taskDescriptionController.text = task['description'];
    // You can set the confirmation photo here if it exists
    // _confirmationPhoto = File(task['confirmationPhoto']);
    setState(() {});
  }

  Widget _buildTaskForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _itemNumberController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Номер задачи',
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _taskDescriptionController,
          decoration: InputDecoration(
            labelText: 'Описание задачи',
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _pickConfirmationPhoto,
          child: Text('Выбрать фотографию подтверждения'),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _addOrUpdateTask();
          },
          child: Text('Добавить/Обновить задачу'),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _tasksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Произошла ошибка при загрузке задач!'));
        } else {
          final tasks = snapshot.data ?? [];
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (ctx, index) {
              final task = tasks[index];
              return ListTile(
                title: Text(task['description']),
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editTask(task);
                  },
                ),
                // отобразить другие детали задачи
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали чек-листа'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Название: ${widget.checklist['title']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Статус: ${widget.checklist['isCompleted'] == 1 ? 'Выполнено' : 'В процессе'}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            _buildTaskForm(),
            SizedBox(height: 20),
            Expanded(
              child: _buildTaskList(),
            ),
          ],
        ),
      ),
    );
  }
}
