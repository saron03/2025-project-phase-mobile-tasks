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

        if (name != null && desc != null && price != null) {
          manager.addProduct(Product(name, desc, price));
          print(' Product added!');
        } else {
          print('Invalid input.');
        }
        break;

      case '2':
        manager.viewProducts();
        break;

      case '3':
        stdout.write('Enter product name to search: ');
        String? name = stdin.readLineSync();
        if (name != null) {
          manager.viewSingleProduct(name);
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

        if (oldName != null && newName != null && newDesc != null && newPrice != null) {
          manager.editProduct(oldName, newName, newDesc, newPrice);
          print("Product edited successfully!");
        } else {
          print('Invalid input.');
        }
        break;

      case '5':
        stdout.write('Enter product name to delete: ');
        String? name = stdin.readLineSync();
        if (name != null) {
          manager.deleteProduct(name);
          print("Product deleted successfully!");
        }
        break;

      case '6':
        running = false;
        print('Exiting...');
        break;

      default:
        print('Invalid choice.');
    }
  }
}
