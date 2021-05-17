import 'dart:io';
import 'Pair.dart';

class Injury {
  /// { {Photo, Caption}, {Photo, Caption}, {Photo, Caption} }
  Pair _title;
  List<Pair> _instructions;

  Injury(File image, String caption) {
    _title = new Pair(image, caption);
    _instructions = [];
  }
  void addStep (File image, String caption) {
    _instructions.add(Pair(image, caption));
  }
  Pair getTitle () {
    return _title;
  }
  List<Pair> getInstructions() {
    return _instructions;
  }

  void load() {
    /// HTTP Request
    /*_instructions.add(new Pair(_title.getImage(), "ARSAD AD SSADA SDA SJ FJGG IRFJ VJNF"));

    _instructions.add(new Pair(_title.getImage(), "AR SAD ADSSA DAS DAS JFJGGI RFJVJNF"));

    _instructions.add(new Pair(_title.getImage(), "ARSADAD SSA DAS DASJFJ GGIRF JVJNF"));

    _instructions.add(new Pair(_title.getImage(), "ARSA DADSS ADASDA SJF JGGIRFJVJ NF"));*/
  }
}