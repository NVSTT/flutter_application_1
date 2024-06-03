import 'package:flutter/material.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import '/screens/checklist_detail.dart';
import 'dart:io';

class ChecklistScreen extends StatefulWidget {
  @override
  _ChecklistScreenState createState() => _ChecklistScreenState();
}


class _ChecklistScreenState extends State<ChecklistScreen> {
    final _formKey = GlobalKey<FormState>(); // Объявление _formKey здесь
    String checklistTitle = '';
    late Future<List<Map<String, dynamic>>> _checklistFuture;
    
    @override
     void _openChecklist(String id) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChecklistDetailScreen(id),
        ),
      );
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
              title: Container(
                color: Colors.grey[800], // серый фон
                padding: EdgeInsets.all(8.0), 
                child: Center(
                child: Text('Чек-лист',
                  style: TextStyle(color: Colors.white), // белый текст
                ),
              ),
            ),
            backgroundColor: Colors.grey[800], // делаем AppBar темно-серым
            elevation: 0, // убираем тень
          ),
        body: FutureBuilder(
          future: _checklistFuture,
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                return Center(child: Text('Произошла ошибка!'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (ctx, index) {
                    return ListTile(
                      title: Text(snapshot.data?[index]['title']),
                      subtitle: Text('Статус: ' + (snapshot.data?[index]['isCompleted'] == 1 ? 'Выполнено' : 'В процессе')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                      ),
                      onTap: () => _openChecklist(snapshot.data?[index]['id']),
                    );
                  },
                );
              }
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
                        if (_formKey.currentState!.validate() ?? false) {
                          DBHelper.addChecklist({
                            'id': DateTime.now().toString(),
                            'title': checklistTitle,
                            'isCompleted': 0,
                          });
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