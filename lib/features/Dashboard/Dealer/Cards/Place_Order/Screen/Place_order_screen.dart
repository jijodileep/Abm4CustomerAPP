import 'package:abm4customerapp/constants/string_constants.dart';
import 'package:abm4customerapp/features/Dashboard/Dealer/Cards/Place_Order/Screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/search_item_bloc.dart';
import '../bloc/search_item_event.dart';
import '../bloc/search_item_state.dart';
import '../models/search_item_model.dart';
import '../providers/cart_provider.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  SearchItem? selectedItem;
  Map<String, int> itemQuantities = {}; // Track quantities for each item
  Map<String, TextEditingController> quantityControllers =
      {}; // Controllers for quantity inputs

  Map<String, SearchItem> itemsMap = {}; // Store item details for cart

  @override
  void dispose() {
    _searchController.dispose();
    // Dispose all quantity controllers
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });

    if (value.trim().isNotEmpty) {
      // Trigger search with BLoC
      context.read<SearchItemBloc>().add(
        SearchItemRequested(searchQuery: value.trim()),
      );
    } else {
      // Clear search results
      context.read<SearchItemBloc>().add(const SearchItemCleared());
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchQuery = '';
      selectedItem = null;
    });
    context.read<SearchItemBloc>().add(const SearchItemCleared());
  }

  void _updateQuantity(String itemId, String value, SearchItem item) {
    int? quantity = int.tryParse(value);
    if (quantity != null && quantity >= 0) {
      setState(() {
        if (quantity == 0) {
          itemQuantities.remove(itemId);
        } else {
          itemQuantities[itemId] = quantity;
        }
      });

      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quantity == 0
                ? '${item.name}: Removed from order'
                : '${item.name}: Quantity $quantity',
          ),
          backgroundColor: quantity == 0 ? Colors.orange : Colors.green,
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  TextEditingController _getQuantityController(String itemId) {
    if (!quantityControllers.containsKey(itemId)) {
      quantityControllers[itemId] = TextEditingController();
    }
    return quantityControllers[itemId]!;
  }

  void _addAllItemsToCart() {
    if (itemQuantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items selected to add to cart'),
          backgroundColor: Colors.orange,
          duration: Duration(milliseconds: 1000),
        ),
      );
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    int itemsAdded = 0;

    // Add all items with quantities to cart
    itemQuantities.forEach((itemId, quantity) {
      if (itemsMap.containsKey(itemId) && quantity > 0) {
        final item = itemsMap[itemId]!;
        cartProvider.addItem(
          itemId,
          item.name ?? 'Unknown Item',
          item.currentSalesPrice ?? 0.0,
          quantity,
        );
        itemsAdded++;
      }
    });

    if (itemsAdded > 0) {
      // Clear current selections after adding to cart
      setState(() {
        itemQuantities.clear();
        for (var controller in quantityControllers.values) {
          controller.clear();
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$itemsAdded items added to cart successfully!'),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No valid items to add to cart'),
          backgroundColor: Colors.orange,
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFCEB007),
        elevation: 2,
        shadowColor: Color(0xFFCEB007).withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
              width: 70,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 25),
            const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 90),
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                      ),
                    ),
                    if (cartProvider.totalItems > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            '${cartProvider.totalItems}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          // Search Field Container
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFFCEB007),
                    width: 2,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Main Content Area - Search Results (Top Half)
          Expanded(
            flex: 1, // Top half of the screen
            child: BlocBuilder<SearchItemBloc, SearchItemState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.error}',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (searchQuery.isNotEmpty) {
                              context.read<SearchItemBloc>().add(
                                SearchItemRequested(searchQuery: searchQuery),
                              );
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.items.isEmpty && searchQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found for "$searchQuery"',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.items.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      final itemId = item.id?.toString() ?? index.toString();
                      final currentQuantity = itemQuantities[itemId] ?? 0;
                      final quantityController = _getQuantityController(itemId);

                      itemsMap[itemId] = item;

                      // Update controller text if quantity changed externally
                      if (quantityController.text !=
                          currentQuantity.toString()) {
                        quantityController.text = currentQuantity == 0
                            ? ''
                            : currentQuantity.toString();
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            // Item Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? 'Unknown Item',
                                    style: const TextStyle(
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item.currentSalesPrice != null)
                                    Text(
                                      '₹${item.currentSalesPrice!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  if (currentQuantity > 0 &&
                                      item.currentSalesPrice != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Total: ₹${(item.currentSalesPrice! * currentQuantity).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          // fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Quantity Input Field
                            Container(
                              width: 50,
                              margin: const EdgeInsets.only(right: 8),
                              child: TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                    4,
                                  ), // Max 4 digits
                                ],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Qty',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: currentQuantity > 0
                                      ? Color(0xFFCEB007).withOpacity(0.1)
                                      : Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: currentQuantity > 0
                                          ? Color(0xFFCEB007).withOpacity(0.5)
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFCEB007),
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: currentQuantity > 0
                                          ? Color(0xFFCEB007).withOpacity(0.5)
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                                onChanged: (value) {
                                  _updateQuantity(itemId, value, item);
                                },
                                onSubmitted: (value) {
                                  _updateQuantity(itemId, value, item);
                                },
                              ),
                            ),

                            // Add item to Cart button (Individual)
                            Container(
                              width: 50,
                              margin: const EdgeInsets.only(right: 8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: currentQuantity > 0
                                      ? Color(0xFFCEB007).withOpacity(0.1)
                                      : Colors.grey[100],
                                  padding: const EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: currentQuantity > 0
                                          ? Color(0xFFCEB007).withOpacity(0.5)
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  if (currentQuantity > 0) {
                                    // Add item to cart
                                    final cartProvider =
                                        Provider.of<CartProvider>(
                                          context,
                                          listen: false,
                                        );
                                    cartProvider.addItem(
                                      itemId,
                                      item.name ?? 'Unknown Item',
                                      item.currentSalesPrice ?? 0.0,
                                      currentQuantity,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${item.name} added to cart!',
                                        ),
                                        backgroundColor: Colors.green,
                                        duration: const Duration(
                                          milliseconds: 1000,
                                        ),
                                      ),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter a quantity first',
                                        ),
                                        backgroundColor: Colors.orange,
                                        duration: Duration(milliseconds: 1000),
                                      ),
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.check,
                                  color: currentQuantity > 0
                                      ? Color(0xFFCEB007)
                                      : Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // Default state - no search
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Search for products to place an order',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Add All Items to Cart Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _addAllItemsToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCEB007),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Add Items to Cart',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Version - ${StringConstant.version}',
                style: TextStyle(
                  color: Color(0xFFCEB007),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
