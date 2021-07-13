import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImageController {
  String base_64;
  String _path;

  ImageController(File file) {
    base_64 = base64Encode(file.readAsBytesSync());
  }
  ImageController.fromAssets(String path) {
    _path = path;
  }

  ImageController.fromBase64(String base64) {
    this.base_64 = base64;
  }
  loadBytesFromAssets() async {
    if (base_64 == null) {
      ByteData bytes = await rootBundle.load(_path);
      base_64 = base64.encode(Uint8List.view(bytes.buffer));
    }
  }

  Uint8List decode() {
    return Base64Codec().decode(base_64);
  }
}
