import 'package:flutter/material.dart';
import 'package:flutter_ui_task_6/add_product.dart';
import 'package:flutter_ui_task_6/details_page.dart';
import 'package:flutter_ui_task_6/models/product.dart';
import 'package:flutter_ui_task_6/search_page.dart';
import 'package:flutter_ui_task_6/models/product_repository.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Shopping",
      initialRoute: '/',
      onGenerateRoute: (settings) {
        late Widget page;
        switch (settings.name) {
          case '/':
            page = const MainPage();
            break;
          case '/addProduct':
            page = const AddProductPage();
            break;
          case '/details':
            // Cast settings.arguments to Product and pass to DetailsPage
            final product = settings.arguments as Product;
            page = DetailsPage(product: product);
            break;
          default:
            page = const MainPage();
        }

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback
  onProductDeletedOrUpdated; // Callback for when a product is deleted/updated via details page

  const ProductCard({
    super.key,
    required this.product,
    required this.onProductDeletedOrUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Made onTap async
        // Use named route for navigation and pass the product as an argument
        final bool? result =
            await Navigator.pushNamed(
                  // Await the result
                  context,
                  '/details',
                  arguments: product,
                )
                as bool?; // Cast the result
        if (result == true) {
          // If result is true, it means a change happened (delete/update)
          onProductDeletedOrUpdated(); // Call the callback to refresh MainPage
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 160,
                child: FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: product.image,
                ),
              ),
            ),
            // Product Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Category and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.category.name,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '(4.5)',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Make productList mutable as it will be updated
  List<Product> _productList = [];

  @override
  void initState() {
    super.initState();
    _loadProducts(); // Load products initially
  }

  void _loadProducts() {
    setState(() {
      _productList = ProductRepository().getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(width: 12),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'July 21, 2025',
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),

                const SizedBox(height: 5),

                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Hello, ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: 'Saron',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.notifications_active_sharp),
                  color: Colors.black,
                  iconSize: 20,
                  onPressed: () {
                    print("Hello");
                  },
                ),
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Available Products",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey), // Gray border
                    borderRadius: BorderRadius.circular(8), // Rounded box
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _productList.length,
              itemBuilder: (context, index) {
                return ProductCard(
                  product: _productList[index],
                  onProductDeletedOrUpdated: _loadProducts, // Pass the callback
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Made onPressed async
          // Use named route for adding a product and await the result
          final bool? result =
              await Navigator.pushNamed(context, '/addProduct') as bool?;
          if (result == true) {
            // If result is true, it means a change happened
            _loadProducts(); // Refresh the product list
          }
        },
        backgroundColor: Colors.deepPurple,
        shape: const CircleBorder(), // ensures circular shape
        child: const Icon(Icons.add, color: Colors.white, size: 40),
      ),
    );
  }
}
