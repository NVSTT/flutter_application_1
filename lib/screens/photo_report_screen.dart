import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PhotoReportScreen extends StatefulWidget {
  @override
  _PhotoReportScreenState createState() => _PhotoReportScreenState();
}

class _PhotoReportScreenState extends State<PhotoReportScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _takePicture() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future<void> _savePicture() async {
    if (_image == null) {
      return;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final filePath = '${directory.path}/$fileName';
      await File(_image!.path).copy(filePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Фото сохранено в $filePath')),
      );
    } catch (e) {
      print('Ошибка при сохранении фото: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при сохранении фото')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Container(
              color: Colors.grey[800], // серый фон
              padding: EdgeInsets.all(8.0), 
              child: Center(
              child: Text('Фотоотчет',
                style: TextStyle(color: Colors.white), // белый текст
              ),
            ),
          ),
          backgroundColor: Colors.grey[800], // делаем AppBar темно-серым
          elevation: 0, // убираем тень
        ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null ? Text('Нет фото') : Image.file(File(_image!.path)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Сделать фото'),
            ),
            SizedBox(height: 10),
            if (_image != null)
              ElevatedButton(
                onPressed: _savePicture,
                child: Text('Сохранить фото'),
              ),
          ],
        ),
      ),
    );
  }
}