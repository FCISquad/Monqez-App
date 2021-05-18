import 'dart:convert';
import 'dart:io';

import 'dart:typed_data';
import 'package:flutter/services.dart';

class ImageController {
  String base_64;
  ImageController(File file) {
    base_64 = base64Encode(file.readAsBytesSync());
  }
  ImageController.fromAssets(String path) {
    Future.delayed(Duration.zero, () async {
      ByteData bytes = await rootBundle.load(path);
      var buffer = bytes.buffer;
      base_64 = base64.encode(Uint8List.view(buffer));
    });
  }
  Uint8List decode() {
    return base_64 == null ? Uint8List(0) :  Base64Codec().decode(base_64);
  }
}
