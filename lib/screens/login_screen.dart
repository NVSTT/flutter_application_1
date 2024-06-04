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
            Image.asset('assets/logo.png', height: 200),
            const SizedBox(height: 40),
            const Text('Контроль и учет строительных работ', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 20),
            Visibility(
              visible: !_showLoginForm, 
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showLoginForm = true;
                  });
                },
                child: const Text('Вход в систему'),
              ),
            ),
            Visibility(
              visible: _showLoginForm,
              child: const LoginForm(),
            ),
          ],
        ),
      ),
    );
  }
}


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

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
          SizedBox(
            width: 300, 
            child: Card(
              color: Colors.white, // Установите белый цвет фона
              child: Padding(
                padding: const EdgeInsets.all(16.0), 
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Логин'),
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
                      decoration: const InputDecoration(labelText: 'Пароль'),
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
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // Handle login logic here
                          final database = await openDatabase(join(await getDatabasesPath(), 'tasks.db'));
                          List<Map> list = await database.rawQuery('SELECT * FROM users WHERE username=? AND password=?', [_username, _password]);
                          if (list.isNotEmpty) {
                            // Login successful
                            Navigator.of(context).pushReplacementNamed('/home');
                          } else {
                            // Login failed
                            print('Login failed');
                          }
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white, // Установите белый цвет кнопки
                        side: const BorderSide(color: Colors.black), // Установите черную обводку
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Установите округлые углы
                        ),
                      ),
                      child: const Text('Войти'),
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


