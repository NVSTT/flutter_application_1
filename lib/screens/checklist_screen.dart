import 'package:flutter/material.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import './checklist_detail.dart';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  final _formKey = GlobalKey<FormState>();
  String checklistTitle = '';
  late Future<List<Map<String, dynamic>>> _checklistFuture;

  @override
  void initState() {
    super.initState();
    _loadChecklists();
  }

  void _loadChecklists() {
    setState(() {
      _checklistFuture = DBHelper.getChecklists();
    });
  }

  void _openChecklist(String id) {
    Navigator.of(context)
        .push(MaterialPageRoute(
          builder: (context) => ChecklistDetailScreen(
            id,
            _formKey,
            checklistTitle,
            DBHelper.getChecklistById(id),
          ),
        ))
        .then((_) => _loadChecklists()); // обновляем список после возвращения с экрана деталей
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
      body: FutureBuilder(
        future: _checklistFuture,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('Произошла ошибка!'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  title: Text(snapshot.data?[index]['title']),
                  subtitle: Text('Статус: ' +
                      (snapshot.data?[index]['isCompleted'] == 1
                          ? 'Выполнено'
                          : 'В процессе')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _openChecklist(snapshot.data?[index]['id']),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          DBHelper.deleteChecklist(snapshot.data?[index]['id']);
                          _loadChecklists();
                        },
                      ),
                    ],
                  ),
                  onTap: () => _openChecklist(snapshot.data?[index]['id']),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Новый чек-лист'),
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
                        DBHelper.addChecklist({
                          'id': DateTime.now().toString(),
                          'title': checklistTitle,
                          'isCompleted': 0,
                        });
                        _loadChecklists();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
