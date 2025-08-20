import 'package:hive/hive.dart';
import 'cart_model.dart';

part 'cart_item_hive.g.dart';

@HiveType(typeId: 0)
class CartItemHive extends HiveObject {
  @HiveField(0)
  String itemId;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  int quantity;

  CartItemHive({
    required this.itemId,
    required this.name,
    required this.price,
    required this.quantity,
  });
  double get total => price * quantity;

  factory CartItemHive.fromCartItem(CartItem item) {
    return CartItemHive(
      itemId: item.itemId,
      name: item.name,
      price: item.price,
      quantity: item.quantity,
    );
  }
  CartItem toCartItem() {
    return CartItem(
      itemId: itemId,
      name: name,
      price: price,
      quantity: quantity,
    );
  }
}
