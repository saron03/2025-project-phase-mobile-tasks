import 'dart:io';
import 'package:product_2/product.dart';
import 'package:product_2/product_manager.dart';

void main() {
  ProductManager manager = ProductManager();
  bool running = true;

  while (running) {
    print('\n=== Product Manager ===');
    print('1. Add Product');
    print('2. View All Products');
    print('3. View Single Product');
    print('4. Edit Product');
    print('5. Delete Product');
    print('6. Exit');
    stdout.write('Choose an option: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter product name: ');
        String? name = stdin.readLineSync();

        stdout.write('Enter description: ');
        String? desc = stdin.readLineSync();

        stdout.write('Enter price: ');
        double? price = double.tryParse(stdin.readLineSync() ?? '');

        // Input validation: disallow empty name/description and non-positive price
        if (name != null && name.isNotEmpty &&
            desc != null && desc.isNotEmpty &&
            price != null && price > 0) {
          manager.addProduct(Product(name, desc, price));
          print('Product added!');
        } else {
          print('Invalid input. Please enter valid name, description, and positive price.');
        }
        break;

      case '2':
        manager.viewProducts();
        break;

      case '3':
        stdout.write('Enter product name to search: ');
        String? name = stdin.readLineSync();
        if (name != null && name.isNotEmpty) {
          manager.viewSingleProduct(name);
        } else {
          print('Invalid input. Please enter a valid product name.');
        }
        break;

      case '4':
        stdout.write('Enter product name to edit: ');
        String? oldName = stdin.readLineSync();

        stdout.write('Enter new name: ');
        String? newName = stdin.readLineSync();

        stdout.write('Enter new description: ');
        String? newDesc = stdin.readLineSync();

        stdout.write('Enter new price: ');
        double? newPrice = double.tryParse(stdin.readLineSync() ?? '');

        if (oldName != null && oldName.isNotEmpty &&
            newName != null && newName.isNotEmpty &&
            newDesc != null && newDesc.isNotEmpty &&
            newPrice != null && newPrice > 0) {
          manager.editProduct(oldName, newName, newDesc, newPrice);
          print("Product edited successfully!");
        } else {
          print('Invalid input. Please provide valid values for all fields.');
        }
        break;

      case '5':
        stdout.write('Enter product name to delete: ');
        String? name = stdin.readLineSync();
        if (name != null && name.isNotEmpty) {
          manager.deleteProduct(name);
          print("Product deleted successfully!");
        } else {
          print('Invalid input. Please enter a valid product name.');
        }
        break;

      case '6':
        running = false;
        print('Exiting...');
        break;

      default:
        print('Invalid choice. Please enter a number between 1 and 6.');
    }
  }
}
