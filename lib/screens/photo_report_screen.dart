import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class PhotoReportScreen extends StatefulWidget {
  const PhotoReportScreen({super.key});

  @override
  _PhotoReportScreenState createState() => _PhotoReportScreenState();
}

class _PhotoReportScreenState extends State<PhotoReportScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  XFile? _tempImage;

  Future<void> _takePicture() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _tempImage = image;
    });
  }

  Future<void> _savePicture() async {
    if (_tempImage != null) {
      final dir = await getApplicationDocumentsDirectory();
      final path = dir.path;
      final newImage = await File(_tempImage!.path).copy('$path/saved_image.jpg');
      setState(() {
        _image = XFile(newImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Container(
              color: Colors.grey[800], // серый фон
              padding: const EdgeInsets.all(8.0), 
              child: const Center(
              child: Text('Фото',
                style: TextStyle(color: Colors.white), // белый текст
              ),
            ),
          ),
          backgroundColor: Colors.grey[800], // делаем AppBar темно-серым
          elevation: 0, // убираем тень
        ),
      body: Center(
        child: Column(
          children: [
            _image == null ? const Text('Нет фото')
                : Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: _takePicture,
              child: const Text('Сделать фото'),
            ),
            ElevatedButton(
              onPressed: _savePicture,
              child: const Text('Сохранить фото'),
            ),
          ]
        ),
      ),
    );
  }
}
