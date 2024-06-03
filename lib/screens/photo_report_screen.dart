import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фотоотчет'),
      ),
      body: Center(
        child: Column(
          children: [
            _image == null ? Text('Нет фото')
                : Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Сделать фото'),
            ),
          ],
        ),
      ),
    );
  }
}