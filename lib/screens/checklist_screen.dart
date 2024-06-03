import 'package:flutter/material.dart';

class ChecklistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чек-лист'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: Text('Чек-лист от 14.03.2024'),
              subtitle: Text('Статус: Выполнено'),
              trailing: Icon(Icons.check, color: Colors.green),
            ),
            ListTile(
              title: Text('Чек-лист от 14.03.2024'),
              subtitle: Text('Статус: В процессе'),
              trailing: Icon(Icons.warning, color: Colors.yellow),
            ),
            FloatingActionButton(
              onPressed: () {
                // Add new checklist
              },
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
