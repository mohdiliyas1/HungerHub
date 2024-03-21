class FoodModel {
  final String? id;
  final String imageUrl;
  final String foodName;
  final String produced;
  final String expiry;
  final String quantity;
  final double rating;

  const FoodModel({
    this.id,
    required this.imageUrl,
    required this.foodName,
    required this.produced,
    required this.expiry,
    required this.quantity,
    required this.rating,
  });

  toJson() {
    return {
      "imageUrl": imageUrl,
      "foodName": foodName,
      "produced": produced,
      "expiry": expiry,
      "quantity": quantity,
      "rating": rating,
    };
  }
}
