import 'package:abm4_customerapp/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_item_bloc.dart';
import '../bloc/search_item_event.dart';
import '../bloc/search_item_state.dart';
import '../models/search_item_model.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  int selectedQuantity = 1;
  SearchItem? selectedItem;

  @override
  void dispose() {
    _searchController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 2,
        shadowColor: Colors.blue.withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
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
                fontWeight: FontWeight.w600,
              ),
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
            child: Row(
              children: [
                // Search Field
                Expanded(
                  flex: 3,
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
                          color: Colors.blue,
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

                const SizedBox(width: 12),

                Row(
                  children: [
                    // Quantity TextField
                    Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          int? newQuantity = int.tryParse(value);
                          if (newQuantity != null &&
                              newQuantity > 0 &&
                              newQuantity <= 99) {
                            setState(() {
                              selectedQuantity = newQuantity;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: 'Qty',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 8,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Add Icon Button
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Colors.blue,
                        size: 32,
                      ),
                      onPressed: () {
                        // Handle add functionality
                        print('Add item with quantity: $selectedQuantity');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content Area - Search Results
          Expanded(
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
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    item.barcode ?? 'Unknown Item',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 4),
                                  if (item.currentSalesPrice != null)
                                    Text(
                                      '₹${item.currentSalesPrice!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Add Button
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedItem = item;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added: ${item.name} (Qty: $selectedQuantity)',
                                    ),
                                    backgroundColor: Colors.green,
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              },
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
                      if (selectedQuantity > 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'Selected Quantity: $selectedQuantity',
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (selectedItem != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  'Selected Item:',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  selectedItem!.name ?? 'Unknown Item',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (selectedItem!.currentSalesPrice != null)
                                  Text(
                                    'Price: ₹${selectedItem!.currentSalesPrice!.toStringAsFixed(2)}',
                                    style: TextStyle(color: Colors.green[600]),
                                  ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Save Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // Handle save functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      searchQuery.isNotEmpty
                          ? 'Saved: "$searchQuery" (Qty: $selectedQuantity)'
                          : 'Saved with quantity: $selectedQuantity',
                    ),
                    backgroundColor: Colors.green,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
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
                'Save Order',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Version - ${StringConstant.version}',
                style: const TextStyle(
                  color: Colors.black,
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
