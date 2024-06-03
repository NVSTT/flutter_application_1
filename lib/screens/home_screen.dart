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
        title: Text('Главная страница'),
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
                height: 60.0,
                child: ListTile(
                  leading: Image.asset('assets/checklist.png'), // замените 'assets/your_logo.png' на путь к вашему логотипу
                  title: Text('Создать чек-лист', style: TextStyle(fontSize: 24, color: Colors.black)),
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
                height: 60.0,
                child: ListTile(
                  leading: Image.asset('assets/calendar.png'), // замените 'assets/your_logo.png' на путь к вашему логотипу
                  title: Text('Календарный план', style: TextStyle(fontSize: 24, color: Colors.black)),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChecklistScreen()));
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
                height: 60.0,
                child: ListTile(
                  leading: Image.asset('assets/photo.png'), // замените 'assets/your_logo.png' на путь к вашему логотипу
                  title: Text('Фотоотчет', style: TextStyle(fontSize: 24, color: Colors.black)),
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
                height: 60.0,
                child: ListTile(
                  leading: Image.asset('assets/docx.png'), // замените 'assets/your_logo.png' на путь к вашему логотипу
                  title: Text('Отчетность', style: TextStyle(fontSize: 24, color: Colors.black)),
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
