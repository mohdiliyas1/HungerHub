import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async {
  print("picking image");
  final ImagePicker imagePicker = ImagePicker();
  print("inside select image");
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
  print("No Images Selected");
}
