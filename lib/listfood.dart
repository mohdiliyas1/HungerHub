import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hungerhub/editfood.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class ListFood extends StatelessWidget {
  const ListFood({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Items",
            style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 5.0,
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('foods').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final foods = snapshot.data?.docs.toList();
            return ListView.builder(
              itemCount: foods?.length,
              itemBuilder: (context, index) {
                final food = foods?[index];
                Widget leadingWidget;
                if (food?['imageUrl'] != '') {
                  print("Inside image loading");
                  leadingWidget = CircleAvatar(
                    backgroundImage: NetworkImage(food?['imageUrl']),
                    radius: 30,
                  );
                } else {
                  leadingWidget = const Icon(Icons.fastfood_outlined);
                }
                Widget trailingWidget = Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RatingBar.readOnly(
                      filledIcon: Icons.star,
                      emptyIcon: Icons.star_border,
                      initialRating: food!['rating'].toDouble(),
                      size: 20.0,
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFoodPage(food),
                            ),
                          );
                        },
                        child: const Icon(Icons.edit)),
                  ],
                );
                return Card(
                  child: ListTile(
                    leading: leadingWidget,
                    title: Text(food?['foodName'], style: TextStyle(fontSize: 18)),
                    subtitle: Text(
                        'Produced: ${food?['produced']}\nExpiry: ${food?['expiry']}\nQuantity: ${food?['quantity']}', style: TextStyle(fontSize: 13)),
                    trailing: trailingWidget,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
