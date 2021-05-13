import 'dart:io';

class Pair {
  File _image;
  String _caption;

  Pair(File image, String caption) {
    _image = image;
    _caption = caption;
  }

  File getImage() {
    return _image;
  }
  String getCaption() {
    return _caption;
  }
}