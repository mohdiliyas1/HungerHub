import 'dart:typed_data';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hungerhub/backends/food_model.dart';
import 'package:hungerhub/backends/food_repository.dart';
import 'package:hungerhub/imagepicker.dart';
import 'package:hungerhub/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class CreateFood extends StatefulWidget {
  const CreateFood({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyFormState();
  }
}

class MyFormState extends State<CreateFood> {
  final _myFormKey = GlobalKey<FormState>();
  var foodName = TextEditingController();
  var productionDate = TextEditingController();
  var expiryDate = TextEditingController();
  var quantity = TextEditingController();
  var rating = 0.0;
  String? imgUrl;
  Uint8List? _image;
  final foodRepo = Get.put(FoodRepository());
  String? customId;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> uploadFoodData() async {
    String customId = const Uuid().v4();
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please upload an Image'),
        duration: Duration(seconds: 3),
      ));
      return;
    }
    print("this is outside imagecheck");
    if (_myFormKey.currentState!.validate()) {
      imgUrl = await foodRepo.uploadImageToStorage("image", _image, customId);
      print("image uploaded with url : $imgUrl");
      FoodModel food = FoodModel(
        imageUrl: imgUrl!.trim(),
        foodName: foodName.text.trim(),
        produced: productionDate.text.trim(),
        expiry: expiryDate.text.trim(),
        quantity: quantity.text.trim(),
        rating: rating,
      );

      await foodRepo.uploadFoodToFirebase(food, customId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food has been created successfully'),
          duration: Duration(seconds: 3),
        ),
      );

      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Input Food",
                style: TextStyle(color: Colors.white, fontSize: 24.0)),
            centerTitle: true,
            backgroundColor: Colors.deepPurpleAccent,
            elevation: 5.0),
        body: SingleChildScrollView(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                children: [
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
                          // Add Photo

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
                        ],
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
                            maxRating: 5,
                            onRatingChanged: (value) {
                              print('$value');
                              setState(() {
                                rating = value.toDouble();
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
                          color: Color.fromARGB(255, 86, 47, 194)))
                ],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Add your action here

            await uploadFoodData();
          },
          child: const Icon(Icons.done_outlined),
        ));
  }
}
