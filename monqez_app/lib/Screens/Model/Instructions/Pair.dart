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

  Map getJson() {
    Map<String, dynamic> mp = {
      "Step Text": _caption,
      "Thumbnail": _image.base_64
    };
    return mp;
  }
}