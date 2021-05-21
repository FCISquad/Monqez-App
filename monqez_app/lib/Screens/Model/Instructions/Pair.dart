import 'package:monqez_app/Screens/Instructions/ImageController.dart';

class Pair {
  ImageController _image;
  String _caption;

  Pair(ImageController image, String caption) {
    _image = image;
    _caption = caption;
  }

  ImageController getImage() {
    return _image;
  }
  String getCaption() {
    return _caption;
  }
}