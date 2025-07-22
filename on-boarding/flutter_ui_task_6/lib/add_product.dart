import 'package:flutter/material.dart';
import 'models/product_repository.dart';
import 'models/product.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;

  const AddProductPage({super.key, this.product});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  Category? category;
  double? price;
  String description = '';

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      name = widget.product!.name;
      category = widget.product!.category;
      price = widget.product!.price;
      description = widget.product!.description;
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final product = Product(
        id: widget.product?.id ?? DateTime.now().millisecondsSinceEpoch,
        name: name,
        category: category ?? Category.Shoes,
        price: price ?? 0.0,
        description: description,
      );

      if (widget.product == null) {
        ProductRepository().addProduct(product);
      } else {
        ProductRepository().updateProduct(product);
      }

      Navigator.pop(context);
    }
  }

  void _deleteProduct() {
    if (widget.product != null) {
      ProductRepository().deleteProduct(widget.product!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    // Back and title
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.product == null ? 'Add  Product/Update Product' : 'Update Product',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Upload image placeholder
                    GestureDetector(
                      onTap: () {
                        // No actual picker, since we use asset images
                      },
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.image_outlined, size: 40),
                              SizedBox(height: 8),
                              Text('upload image'),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Text('name'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: name,
                      decoration: _inputDecoration(),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter name' : null,
                      onSaved: (value) => name = value ?? '',
                    ),

                    const SizedBox(height: 16),

                    const Text('category'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Category>(
                      value: category,
                      decoration: _inputDecoration(),
                      items: Category.values.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          category = value;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Select category' : null,
                    ),

                    const SizedBox(height: 16),

                    const Text('price'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: price?.toString(),
                      decoration: _inputDecoration(
                        suffixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter price' : null,
                      onSaved: (value) => price = double.tryParse(value ?? '0'),
                    ),

                    const SizedBox(height: 16),

                    const Text('description'),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: description,
                      maxLines: 5,
                      decoration: _inputDecoration(),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Enter description'
                          : null,
                      onSaved: (value) => description = value ?? '',
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
                        widget.product == null ? 'ADD' : 'UPDATE',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),

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
