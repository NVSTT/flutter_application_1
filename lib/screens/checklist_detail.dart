import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import 'package:image_picker/image_picker.dart';

class ChecklistDetailScreen extends StatefulWidget {
  final String checklistId;
  final GlobalKey<FormState> formKey;
  final String checklistTitle;
  final Future<List<Map<String, dynamic>>> checklistFuture;

  ChecklistDetailScreen(
      this.checklistId, this.formKey, this.checklistTitle, this.checklistFuture);

  @override
  _ChecklistDetailScreenState createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  late GlobalKey<FormState> _formKey;
  late String checklistTitle;
  late Future<List<Map<String, dynamic>>> _checklistFuture;
  late TextEditingController _titleController;
  late String? _photoPath;

  @override
    void initState() {
      super.initState();
      _checklistFuture = DBHelper.getChecklistItems(widget.checklistId);
    }

    void _editChecklist(int itemNumber) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Редактировать задачу'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите описание задачи';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Описание',
                    ),
                  ),
                  SizedBox(height: 10),
                  _photoPath == null
                      ? Text('Фотография не выбрана.')
                      : Image.file(File(_photoPath!)),
                  ElevatedButton(
                    onPressed: () => _pickImage(),
                    child: Text('Выбрать фото'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Отмена'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Сохранить'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DBHelper.updateChecklistItem(itemNumber, {
                      'description': _titleController.text,
                      'confirmationPhoto': _photoPath ?? '',
                    });
                    setState(() {
                      _checklistFuture = DBHelper.getChecklistItems(widget.checklistId);
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          );
        },
      );
    }

    void _deleteChecklist(int itemNumber) {
      DBHelper.deleteChecklistItem(itemNumber);
      Navigator.of(context).pop();
    }

    void _toggleChecklistCompleted(int itemNumber, int isCompleted) {
      DBHelper.updateChecklistItem(itemNumber, {'isCompleted': isCompleted == 1 ? 0 : 1});
      setState(() {
        _checklistFuture = DBHelper.getChecklistItems(widget.checklistId);
      });
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

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали чек-листа'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _checklistFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Произошла ошибка!'));
          } else {
            if (snapshot.data!.isEmpty) {
              return Center(child: Text('Чек-лист не найден.'));
            }
            var checklist = snapshot.data!.first;
            _titleController.text = checklist['title'];
            _photoPath = checklist['photo'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите название';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Название',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Статус: ' +
                      (checklist['isCompleted'] == 1 ? 'Выполнено' : 'В процессе')),
                  SizedBox(height: 20),
                  _photoPath == null
                      ? Text('Фотография не выбрана.')
                      : Image.file(File(_photoPath!)),
                  ElevatedButton(
                    onPressed: () => _pickImage(),
                    child: Text('Выбрать фото'),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _editChecklist(int.parse(widget.checklistId)),
                        child: Text('Редактировать'),
                      ),
                      ElevatedButton(
                        onPressed: () => _deleteChecklist(int.parse(widget.checklistId)),
                        child: Text('Удалить'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: () => _toggleChecklistCompleted(
                            (int.parse(widget.checklistId)), checklist['isCompleted']),
                        child: Text(checklist['isCompleted'] == 1
                            ? 'Отметить как невыполненное'
                            : 'Отметить как выполненное'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
