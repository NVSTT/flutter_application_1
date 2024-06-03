import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';

class PhotoReportScreen extends StatefulWidget {
  @override
  _PhotoReportScreenState createState() => _PhotoReportScreenState();
}

class _PhotoReportScreenState extends State<PhotoReportScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  List<AssetEntity> _photos = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _takePicture() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
      _loadPhotos();  // Reload photos after taking a new picture
    });
  }

  Future<void> _loadPhotos() async {
    final permitted = await PhotoManager.requestPermission();
    if (permitted) {
      final albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      final recentAlbum = albums.first;
      final photos = await recentAlbum.getAssetListPaged(0, 100);  // Corrected method call
      setState(() {
        _photos = photos;
      });
    }
  }

  Future<void> _savePicture() async {
    if (_image == null) {
      return;
    }

    try {
      final file = File(_image!.path);
      final result = await PhotoManager.editor.saveImageWithPath(file.path);
      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Фото сохранено')),
        );
        _loadPhotos();  // Reload photos after saving a new picture
      } else {
        throw Exception('Failed to save image');
      }
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
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: _photos.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<File?>(
                    future: _photos[index].file,
                    builder: (context, snapshot) {
                      final file = snapshot.data;
                      if (file == null) {
                        return Container(color: Colors.grey);
                      }
                      return Image.file(file, fit: BoxFit.cover);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
