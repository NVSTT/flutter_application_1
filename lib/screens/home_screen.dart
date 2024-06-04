import 'package:flutter/material.dart';
import './checklist_screen.dart';
import './calendar_screen.dart';
import './photo_report_screen.dart';
import './report_screen.dart';
import './login_screen.dart';
import 'package:flutter_application_1/sqflite/db_helper.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  
  @override
  void _showSettingsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Настройки"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Сменить пароль"),
              onTap: () {
                // смене пароля
                Navigator.pop(context); // диалоговое окно
              },
            ),
            ListTile(
              title: Text("Изменить фотографию профиля"),
              onTap: () {
                // фотографии профиля
                Navigator.pop(context); //диалоговое окно
              },
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Container(
              color: Colors.grey[800], 
              padding: const EdgeInsets.all(8.0), 
              child: const Center(
              child: Text('Главная страница',
                style: TextStyle(color: Colors.white), 
              ),
            ),
          ),
          backgroundColor: Colors.grey[800], 
          elevation: 0, 
        ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[ 
            FutureBuilder(
              future: DBHelper.getData('users'),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  if (snapshot.error != null) {
                    return const Center(child: Text('Произошла ошибка!'));
                  } else {
                    var userData = snapshot.data;
                    if (userData == null) {
                      return const Center(child: Text('Данные пользователя отсутствуют'));
                    }
                    String firstName = userData['firstName'] ?? '';
                    String lastName = userData['lastName'] ?? '';
                    String rank = userData['rank'] ?? '';
                    return UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                          color: Colors.grey[800], // делаем фон серым
                        ),
                      accountName: Text('$firstName $lastName'),
                      accountEmail: Text(rank),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: FileImage(File('assets/user_photo.jpg')),
                      ),
                    );
                  }
                }
              },
            ),

            ListTile(
              title: const Text('Создать чек-лист'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChecklistScreen()));
              },
            ),
            ListTile(
              title: const Text('Календарный план'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CalendarScreen()));
              },
            ),
            ListTile(
              title: const Text('Фотоотчет'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PhotoReportScreen()));
              },
            ),
            ListTile(
              title: const Text('Отчетность'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ReportScreen()));
              },
            ),
            const Divider(), // Добавляем полоску
            ListTile(
              title: const Text('Настройки'),
              onTap: () {
                _showSettingsDialog(context);
              },
            ),
            ListTile(
              title: const Text('Выход'),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ));
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
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/checklist.png'),
                  title: const Center( // Добавлено центрирование
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
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/calendar.png'),
                  title: const Center( // Добавлено центрирование
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
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/photo.png'),
                  title: const Center( // Добавлено центрирование
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
              margin: const EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: SizedBox(
                height: 130.0,
                child: ListTile(
                  leading: Image.asset('assets/docx.png'),
                  title: const Center( // Добавлено центрирование
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
