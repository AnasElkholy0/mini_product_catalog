// ignore_for_file: avoid_print
// (print is used on purpose: the assignment asks for lifecycle messages.)

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// First page of the app. A simple "Guest" login.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Called once, when the State object is first created.
  @override
  void initState() {
    super.initState();
    print("LoginPage: initState");
  }

  // Called right after initState, and again if an inherited
  // widget this page depends on changes.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("LoginPage: didChangeDependencies");
  }

  // Called when the widget is removed from the tree (it may be
  // re-inserted, but usually dispose follows).
  @override
  void deactivate() {
    print("LoginPage: deactivate");
    super.deactivate();
  }

  // Called when the State is permanently removed.
  @override
  void dispose() {
    print("LoginPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage: build");
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.primaryContainer,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.storefront, size: 72, color: colors.primary),
                    const SizedBox(height: 16),
                    Text(
                      'Mini Product Catalog',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover products you love.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Continue as Guest',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                        onPressed: () {
                          // goNamed REPLACES the stack with /products,
                          // so the user cannot go "back" to Login.
                          // The username travels as a QUERY parameter:
                          //   /products?user=Guest
                          context.goNamed(
                            'products',
                            queryParameters: {'user': 'Guest'},
                          );
                        },
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
}
