import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungerhub/backends/food_model.dart';
import 'package:hungerhub/backends/food_repository.dart';
import 'package:hungerhub/main.dart';
import 'package:hungerhub/imagepicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class EditFoodPage extends StatefulWidget {
  QueryDocumentSnapshot<Object?>? food;
  EditFoodPage(this.food, {super.key});

  @override
  State<StatefulWidget> createState() {
    return MyFormState(food);
  }
}

class MyFormState extends State<EditFoodPage> {
  QueryDocumentSnapshot<Object?>? food;
  MyFormState(this.food);

  final _myFormKey = GlobalKey<FormState>();
  late TextEditingController foodName;
  late TextEditingController productionDate;
  late TextEditingController expiryDate;
  late TextEditingController quantity;
  double rating = 0.0;
  String? customId;
  String? imgUrl;
  Uint8List? _image;
  final foodRepo = Get.put(FoodRepository());

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> uploadFoodData() async {
    if (_image != null) {
      imgUrl = await foodRepo.uploadImageToStorage("image", _image, customId!);
    }
    print("image uploaded with url : $imgUrl");
    if (_myFormKey.currentState!.validate()) {
      FoodModel food = FoodModel(
        imageUrl: imgUrl?.trim() ?? '',
        foodName: foodName.text.trim(),
        produced: productionDate.text.trim(),
        expiry: expiryDate.text.trim(),
        quantity: quantity.text.trim(),
        rating: rating.toDouble(),
      );

      await foodRepo.uploadFoodToFirebase(food, customId!);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food data has been edited successfully'),
          duration: Duration(seconds: 3),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    }
  }

  Future<Uint8List?> getImageFromUrl(String imageUrl) async {
    try {
      HttpClient httpClient = HttpClient();
      HttpClientRequest request = await httpClient.getUrl(Uri.parse(imageUrl));
      HttpClientResponse response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        List<int> bytes =
            await response.fold<List<int>>([], (b, d) => b..addAll(d));
        httpClient.close();
        return Uint8List.fromList(bytes);
      } else {
        print('Failed to load image : ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error loading image: $error');
      return null;
    }
  }

  void deleteFood() async {
    await FirebaseFirestore.instance.collection('foods').doc(customId).delete();
    await FirebaseStorage.instance.ref().child('image/$customId').delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Food data has been deleted'),
      duration: Duration(seconds: 3),
    ));
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
  }

  void loadImagefromUrl() async {
    Uint8List? img = await getImageFromUrl(food!['imageUrl']);
    setState(() {
      _image = img;
    });
  }

  @override
  void initState() {
    super.initState();
    customId = food!.id;
    foodName = TextEditingController(text: food!['foodName']);
    productionDate = TextEditingController(text: food!['produced']);
    expiryDate = TextEditingController(text: food!['expiry']);
    quantity = TextEditingController(text: food!['quantity']);
    rating = food!['rating'].toDouble();
    loadImagefromUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Edit Food",
                style: TextStyle(color: Colors.white, fontSize: 24.0)),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 156, 169, 40),
            elevation: 5.0),
        body: SingleChildScrollView(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
                  // Add Photo
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(children: [
                        _image != null
                            ? CircleAvatar(
                                radius: 80,
                                backgroundImage: MemoryImage(_image!),
                              )
                            : const CircleAvatar(
                                radius: 80,
                                backgroundImage: AssetImage('assets/food.png')),
                        Positioned(
                          bottom: -10,
                          left: 120,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(Icons.add_a_photo),
                          ),
                        )
                      ])),

                  Form(
                      key: _myFormKey,
                      child: Column(
                        children: <Widget>[
                          // Food Name
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: foodName,
                                validator: (String? name) {
                                  if (name == null || name.isEmpty) {
                                    return "Please Enter Food Name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Food Name",
                                  hintText: "Enter food name",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              )),

                          // Production Date
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: productionDate,
                                keyboardType: TextInputType.phone,
                                validator: (String? date) {
                                  if (date == null || date.isEmpty) {
                                    return "Please Enter Production Date";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Production Date",
                                  hintText: "DD-MM-YYYY",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              )),

                          // Expiry Date
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: expiryDate,
                                keyboardType: TextInputType.phone,
                                validator: (String? date) {
                                  if (date == null || date.isEmpty) {
                                    return "Please Enter Expiry Date";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Date of Expiry",
                                  hintText: "YYYY-MM-DD",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              )),

                          // Quantity
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                controller: quantity,
                                keyboardType: TextInputType.number,
                                validator: (String? weight) {
                                  if (weight == null || weight.isEmpty) {
                                    return "Please Enter Food Weight";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: "Quantity",
                                  hintText: "in Kgs",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                ),
                              )),

                          // Rating Bar
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBar(
                                    filledIcon: Icons.star,
                                    emptyIcon: Icons.star_border,
                                    initialRating: rating.toDouble(),
                                    maxRating: 5,
                                    onRatingChanged: (value) {
                                      print('$value');
                                      setState(() {
                                        rating = value;
                                      });
                                    }),
                              ],
                            ),
                          ),

                          // Rating Text
                          Text(
                              rating == 0
                                  ? "Rate Quality"
                                  : rating == 1
                                      ? "Very Poor"
                                      : rating == 2
                                          ? "Poor"
                                          : rating == 3
                                              ? "Good"
                                              : rating == 4
                                                  ? "Very Good"
                                                  : rating == 5
                                                      ? "Excellent"
                                                      : "Error Occurred",
                              style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 86, 47, 194))),

                          // Button
                          Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: ElevatedButton(
                                onPressed: deleteFood,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(120, 50)),
                                child: const Icon(
                                  Icons.delete,
                                  size: 30,
                                ),
                              )),
                        ],
                      )),
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your action here

            uploadFoodData();
          },
          child: const Icon(Icons.done_outlined),
        ));
  }
}
