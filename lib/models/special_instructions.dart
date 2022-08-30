import 'dart:convert';
import 'dart:typed_data';

class SpecialInstructions {
  String instructions;
  Uint8List instructionImage;


  SpecialInstructions(this.instructions, this.instructionImage);

  static SpecialInstructions fromJson(json) {
    String instructions = json['instructions'];
    Uint8List instructionImage = base64Decode(json['instructionImage']);
    return SpecialInstructions(instructions, instructionImage);
  }

  static SpecialInstructions empty() {
    return SpecialInstructions("", Uint8List(0));
  }

  static toJson(SpecialInstructions specialInstructions) {
    return {
      'instructions': specialInstructions.instructions,
      'instructionImage': base64Encode(specialInstructions.instructionImage)
    };
  }

}