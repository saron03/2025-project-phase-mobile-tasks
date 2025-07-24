import 'package:flutter/material.dart';
import 'models/product_repository.dart';
import 'models/product.dart'; // Ensure this import is correct

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  Category? _selectedCategory;
  Product? _existingProduct;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_existingProduct == null) {
      final product = ModalRoute.of(context)!.settings.arguments;
      if (product != null && product is Product) {
        _existingProduct = product;
        _nameController.text = _existingProduct!.name;
        _selectedCategory = _existingProduct!.category;
        _priceController.text = _existingProduct!.price.toString();
        _descriptionController.text = _existingProduct!.description;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // In add_product.dart, inside _AddProductPageState

void _saveProduct() {
  if (_formKey.currentState!.validate()) {
    final newProduct = Product(
      id: _existingProduct?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _nameController.text,
      category: _selectedCategory ?? Category.Shoes,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text,
    );

    if (_existingProduct == null) {
      ProductRepository().addProduct(newProduct);
    } else {
      ProductRepository().updateProduct(newProduct);
    }

    Navigator.pop(context, true);
  }
}

  void _deleteProduct() {
    if (_existingProduct != null) {
      ProductRepository().deleteProduct(_existingProduct!.id);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = _existingProduct != null;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.purpleAccent),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isEditing ? 'Update Product' : 'Add New Product',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    GestureDetector(
                      onTap: () {
                        // TODO: Implement actual image selection if you want users to pick new images
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                          // CORRECTED LINE HERE:
                          image: _existingProduct?.image != null
                              ? DecorationImage(
                                  image: _existingProduct!.image.image, // Directly access the ImageProvider from the Image widget
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _existingProduct?.image == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.image_outlined, size: 40),
                                    SizedBox(height: 8),
                                    Text('Upload Image'),
                                  ],
                                ),
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text('Name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Please enter a name' : null,
                    ),

                    const SizedBox(height: 16),

                    const Text('Category'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Category>(
                      value: _selectedCategory,
                      decoration: _inputDecoration(),
                      items: Category.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select a category' : null,
                    ),

                    const SizedBox(height: 16),

                    const Text('Price'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _priceController,
                      decoration: _inputDecoration(
                        suffixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    const Text('Description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 5,
                      decoration: _inputDecoration(),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter a description'
                          : null,
                    ),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _saveProduct,
                      child: Text(
                        isEditing ? 'UPDATE' : 'ADD',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

                    if (isEditing) ...[
                      const SizedBox(height: 12),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _deleteProduct,
                        child: const Text(
                          'DELETE',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
    );
  }
}