import 'package:flutter_application_1/sqflite/db_helper.dart';
import '/screens/checklist_screen.dart';
import 'dart:io';

class ChecklistDetailScreen extends StatefulWidget {
  final String checklistId;

  ChecklistDetailScreen(this.checklistId);

  @override
  _ChecklistDetailScreenState createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  @override
    void initState() {
      super.initState();
      _checklistFuture = DBHelper.getChecklists();
    }

    void _addChecklist() {
      if (_formKey.currentState!.validate()) {
        DBHelper.addChecklist({
          'id': DateTime.now().toString(),
          'title': checklistTitle,
          'isCompleted': 0,
        });
        setState(() {
          _checklistFuture = DBHelper.getChecklists();
        });
      }
    }

    void _editChecklist(String id) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Редактировать чек-лист'),
            content: Form(
              key: _formKey,
              child: TextFormField(
                onChanged: (value) {
                  checklistTitle = value;
                },
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
                    DBHelper.updateChecklist(id, {'title': checklistTitle});
                    setState(() {
                      _checklistFuture = DBHelper.getChecklists();
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

    void _deleteChecklist(String id) {
      DBHelper.deleteChecklist(id);
      setState(() {
        _checklistFuture = DBHelper.getChecklists();
      });
    }

    void _toggleChecklistCompleted(String id, int isCompleted) {
      DBHelper.updateChecklist(id, {'isCompleted': isCompleted == 1 ? 0 : 1});
      setState(() {
        _checklistFuture = DBHelper.getChecklists();
      });
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
    );
  }
}
