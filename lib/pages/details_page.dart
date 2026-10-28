// ignore_for_file: avoid_print
// (print is used on purpose: the assignment asks for lifecycle messages.)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatefulWidget {
  final String name;
  final int price;

  const DetailsPage({super.key, required this.name, required this.price});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    print("DetailsPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("DetailsPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("DetailsPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("DetailsPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("DetailsPage: build");
    final colors = Theme.of(context).colorScheme;
    final name = widget.name;
    final price = widget.price;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: colors.primaryContainer,
        // Clear back navigation. If the page was opened directly from a
        // URL (nothing to pop), go to the products page instead.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/products');
            }
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundColor: colors.primaryContainer,
                  child: Icon(
                    Icons.inventory_2,
                    size: 72,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$$price',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Add to Cart'),
                    onPressed: () {
                      // pop removes this page and sends a result back to
                      // the `await context.push<String>(...)` in
                      // ProductsPage.
                      context.pop("$name added to cart");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
