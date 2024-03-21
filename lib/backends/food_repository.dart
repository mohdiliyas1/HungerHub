import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hungerhub/backends/food_model.dart';

class FoodRepository extends GetxController {
  static FoodRepository get instance => Get.find();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List? file, String imageName) async {
    print("in upload image");
    Reference ref = _storage.ref().child(childName).child(imageName);
    UploadTask uploadTask = ref.putData(file!);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> uploadFoodToFirebase(FoodModel food, String customId) async {
    print("uploading food");
    await _firestore.runTransaction((transaction) async {
      transaction.set(
        _firestore.collection('foods').doc(customId),
        food.toJson(),
      );
    });
  }
}
