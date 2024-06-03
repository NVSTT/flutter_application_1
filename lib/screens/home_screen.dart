import 'package:flutter/material.dart';
import './checklist_screen.dart';
import './calendar_screen.dart';
import './photo_report_screen.dart';
import './report_screen.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
              color: Colors.grey[800], // серый фон
              padding: EdgeInsets.all(8.0), 
              child: Center(
              child: Text('Главная страница',
                style: TextStyle(color: Colors.white), // белый текст
              ),
            ),
          ),
          backgroundColor: Colors.grey[800], // делаем AppBar темно-серым
          elevation: 0, // убираем тень
        ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[ 
            FutureBuilder(
              future: DBHelper.getData('users'),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.error != null) {
                    return Center(child: Text('Произошла ошибка!'));
                  } else {
                    var userData = snapshot.data;
                    if (userData == null) {
                      return Center(child: Text('Данные пользователя отсутствуют'));
                    }
                    String firstName = userData['firstName'] ?? '';
                    String lastName = userData['lastName'] ?? '';
                    String rank = userData['rank'] ?? '';
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.grey[800], // делаем фон серым
                        ),
                      accountName: Text(firstName + ' ' + lastName),
                      accountEmail: Text(rank),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: FileImage(File(userData['photo'])),
                      ),
                    );
                  }
                }
              },
            ),

            ListTile(
              title: Text('Создать чек-лист'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChecklistScreen()));
              },
            ),
            ListTile(
              title: Text('Календарный план'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CalendarScreen()));
              },
            ),
            ListTile(
              title: Text('Фотоотчет'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhotoReportScreen()));
              },
            ),
            ListTile(
              title: Text('Отчетность'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReportScreen()));
              },
            ),
            Divider(), // Добавляем полоску
            ListTile(
              title: Text('Настройки'),
              onTap: () {
                // Ваш код для перехода к экрану настроек...
              },
            ),
            ListTile(
              title: Text('Выход'),
              onTap: () {
                // Ваш код для выхода из системы...
              },
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/checklist.png'),
                  title: Center( // Добавлено центрирование
                    child: Text('Создать чек-лист', style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>  ChecklistScreen()));
                  },
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/calendar.png'),
                  title: Center( // Добавлено центрирование
                    child: Text('Календарный план', style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CalendarScreen()));
                  },
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/photo.png'),
                  title: Center( // Добавлено центрирование
                    child: Text('Фотоотчет', style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => PhotoReportScreen()));
                  },
                ),
              ),
            ),
            Card(
              color: Colors.white,
              margin: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/docx.png'),
                  title: Center( // Добавлено центрирование
                    child: Text('Отчетность', style: TextStyle(fontSize: 30, color: Colors.black)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ReportScreen()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
