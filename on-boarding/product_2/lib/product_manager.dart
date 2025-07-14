import 'package:product_2/product.dart';

class ProductManager {
  List<Product> products = [];

   void addProduct(Product item) {
    // Prevent adding duplicate product names
    for (var product in products) {
      if (product.name == item.name) {
        print('Product with this name already exists.');
        return;
      }
    }
    products.add(item);
  }

  void viewProducts() {
  for (Product x in products) {
    print("The product's name: ${x.name}");
    print("The product's description: ${x.description}");
    print("The product's price: \$${x.price}");
    print('-----------------------');
  }
  }

  void viewSingleProduct(String name){
    for (Product item in products){
      if (item.name == name) {
        print("The product's name: ${item.name}");
        print("The product's description: ${item.description}");
        print("The product's price: \$${item.price}");
        print('-----------------------');
        return;
      }
    } 
   print("No such product exists");
  }
  
  void editProduct(String name, String newName, String newDescription, double newPrice) {
    for (var item in products) {
      if (item.name == name) {
        item.name = newName;
        item.description = newDescription;
        item.price = newPrice;
        print('Product updated successfully.');
        return;
      }
    }
    print('Product not found.');
  }

  void deleteProduct(String name){
    for (var item in products) {
      if (item.name == name) {
        products.remove(item);
        print('Product deleted successfully.');
        return;
      }
    }
  }
}