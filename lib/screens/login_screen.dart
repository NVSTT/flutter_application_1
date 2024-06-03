import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showLoginForm = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 150),
            SizedBox(height: 40),
            Text('Контроль и учет строительных работ', style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),
            Visibility(
              visible: !_showLoginForm, 
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showLoginForm = true;
                  });
                },
                child: Text('Вход в систему'),
              ),
            ),
            Visibility(
              visible: _showLoginForm,
              child: LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 300, 
            child: Card(
              color: Colors.white, // Установите белый цвет фона
              child: Padding(
                padding: EdgeInsets.all(16.0), 
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Логин'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите логин';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value!;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Пароль'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите пароль';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Handle login logic here
                          final database = await openDatabase(join(await getDatabasesPath(), 'tasks.db'));
                          List<Map> list = await database.rawQuery('SELECT * FROM users WHERE username=? AND password=?', [_username, _password]);
                          if (list.length > 0) {
                            // Login successful
                            Navigator.of(context).pushReplacementNamed('/home');
                          } else {
                            // Login failed
                            print('Login failed');
                          }
                        }
                      },
                      child: Text('Войти'),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white, // Установите белый цвет кнопки
                        side: BorderSide(color: Colors.black), // Установите черную обводку
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Установите округлые углы
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


