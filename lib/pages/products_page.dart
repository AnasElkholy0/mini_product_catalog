// ignore_for_file: avoid_print
// (print is used on purpose: the assignment asks for lifecycle messages.)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../product_widgets.dart';

/// Sample data. Each product is a Map with `name` (String) and
/// `price` (int), which is what the helper widgets expect.
final List<Map<String, dynamic>> products = [
  {"name": "Laptop", "price": 1200},
  {"name": "Smartphone", "price": 800},
  {"name": "Headphones", "price": 150},
  {"name": "Smart Watch", "price": 220},
  {"name": "Keyboard", "price": 75},
  {"name": "Mouse", "price": 35},
  {"name": "Monitor", "price": 300},
  {"name": "Tablet", "price": 450},
];

class ProductsPage extends StatefulWidget {
  /// Username received from the query parameter (?user=Guest).
  final String username;

  const ProductsPage({super.key, required this.username});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  int favorites = 0; // local state, changed with setState
  String cartMessage = ''; // result returned from DetailsPage
  Size screenSize = Size.zero; // updated in didChangeDependencies

  @override
  void initState() {
    super.initState();
    print("ProductsPage: initState");
  }

  // MediaQuery.sizeOf(context) makes this State a *dependent* of the
  // inherited MediaQuery widget. When the window is resized, MediaQuery
  // receives new data and Flutter calls didChangeDependencies() again
  // (then build()). No setState is needed here: build() always runs
  // right after this method.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    screenSize = size;
    print(
      "ProductsPage: didChangeDependencies -> "
      "width: ${size.width}, height: ${size.height}",
    );
  }

  @override
  void deactivate() {
    print("ProductsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("ProductsPage: dispose");
    super.dispose();
  }

  /// Called by the heart button of any product.
  void _onFavoritePressed() {
    setState(() {
      favorites++;
    });
  }

  /// Called when a product is tapped: open DetailsPage and wait for
  /// the result it returns.
  Future<void> _openDetails(int index) async {
    final product = products[index];
    final String name = product["name"].toString();
    final int price = product["price"] as int;

    // push adds DetailsPage on top of this page and lets us await
    // a result. The name is encoded because it may contain spaces.
    final result = await context.push<String>(
      '/details/${Uri.encodeComponent(name)}/$price',
    );

    // The page may have been closed while we were waiting.
    if (!mounted) return;

    if (result != null) {
      setState(() {
        cartMessage = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("ProductsPage: build");
    final width = screenSize.width;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Product Catalog'),
        backgroundColor: colors.primaryContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${widget.username}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 24,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 20),
                        const SizedBox(width: 6),
                        Text('Favorites: $favorites'),
                      ],
                    ),
                    Text("Screen width: ${width.toStringAsFixed(0)}"),
                  ],
                ),
                if (cartMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: colors.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart,
                          color: colors.onSecondaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cartMessage,
                            style: TextStyle(
                              color: colors.onSecondaryContainer,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Responsive layout: list on narrow screens, grid on wide ones.
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: width < 600
                  ? ProductsListView(
                      products: products,
                      onFavoritePressed: _onFavoritePressed,
                      onProductTap: _openDetails,
                    )
                  : ProductsGridView(
                      products: products,
                      onFavoritePressed: _onFavoritePressed,
                      onProductTap: _openDetails,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
