import 'package:flutter/material.dart';
import 'models/product.dart';
import 'models/product_repository.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ProductRepository _repository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  double _priceFilter = 0.0;
  String _searchQuery = '';
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _repository.getAllProducts();
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
      _filteredProducts = _repository.getAllProducts().where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_searchQuery) ||
            product.description.toLowerCase().contains(_searchQuery);
        final matchesCategory = _categoryController.text.isEmpty ||
            product.category.toString().contains(_categoryController.text);
        final matchesPrice = product.price <= _priceFilter || _priceFilter == 0.0;
        return matchesSearch && matchesCategory && matchesPrice;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Search Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Leather',
                      suffixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.filter_list, color: Colors.blue),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return Card(
                    child: Column(
                      children: [
                        product.image,
                        ListTile(
                          title: Text(product.name),
                          subtitle: Text('${product.category.toString().split('.').last}'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${product.price.toStringAsFixed(2)}'),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('(4.0)'),
                                  Icon(Icons.star, color: Colors.yellow),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                    onChanged: (_) => _filterProducts(),
                  ),
                  SizedBox(height: 16),
                  Text('Price'),
                  Slider(
                    value: _priceFilter,
                    max: 500,
                    divisions: 50,
                    label: _priceFilter.toStringAsFixed(0),
                    onChanged: (value) {
                      setState(() {
                        _priceFilter = value;
                        _filterProducts();
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                  width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _filterProducts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white, // This ensures the text and icons are white
                      ),
                      child: Text('APPLY'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _categoryController.dispose();
    super.dispose();
  }
}