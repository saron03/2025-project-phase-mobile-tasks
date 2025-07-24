import 'product.dart';

class ProductRepository {
  static final List<Product> _products = [
    Product(
      id: 1,
      name: 'All Stars',
      category: Category.Shoes,
      price: 120.0,
      description: 'The All Stars sneakers are a timeless classic. Built with a durable canvas upper and rubber sole, '
          'they’re perfect for everyday casual wear, skateboarding, or weekend outings. Loved by all generations, '
          'these shoes bring both comfort and legacy to your feet.',
    ),
    Product(
      id: 1,
      name: 'All Stars',
      category: Category.Shoes,
      price: 120.0,
      description: 'The All Stars sneakers are a timeless classic. Built with a durable canvas upper and rubber sole, '
          'they’re perfect for everyday casual wear, skateboarding, or weekend outings. Loved by all generations, '
          'these shoes bring both comfort and legacy to your feet.',
    ),
    Product(
      id: 1,
      name: 'All Stars',
      category: Category.Shoes,
      price: 120.0,
      description: 'The All Stars sneakers are a timeless classic. Built with a durable canvas upper and rubber sole, '
          'they’re perfect for everyday casual wear, skateboarding, or weekend outings. Loved by all generations, '
          'these shoes bring both comfort and legacy to your feet.',
    ),
    Product(
      id: 1,
      name: 'All Stars',
      category: Category.Shoes,
      price: 120.0,
      description: 'The All Stars sneakers are a timeless classic. Built with a durable canvas upper and rubber sole, '
          'they’re perfect for everyday casual wear, skateboarding, or weekend outings. Loved by all generations, '
          'these shoes bring both comfort and legacy to your feet.',
    ),
  ];

  List<Product> getAllProducts() {
    return _products;
  }

  List<Product> getAllShoes() {
    return _products.where((p) => p.category == Category.Shoes || p.category == Category.WomensShoes || p.category == Category.MensShoes).toList();
  }

  List<Product> getAllClothes() {
    return _products.where((p) => p.category == Category.Clothing).toList();
  }

  List<Product> getAllBags() {
    return _products.where((p) => p.category == Category.Bags).toList();
  }

  List<Product> getAllAccessories() {
    return _products.where((p) => p.category == Category.Accessories).toList();
  }

    void addProduct(Product product) {
    _products.add(product);
  }

  void updateProduct(Product updatedProduct) {
    final index = _products.indexWhere((p) => p.id == updatedProduct.id);
    if (index != -1) {
      _products[index] = updatedProduct;
    }
  }

  void deleteProduct(int id) {
    _products.removeWhere((p) => p.id == id);
  }

}
