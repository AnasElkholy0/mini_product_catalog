/*
=====================================================================
 PART FOUR: REQUIRED SHORT ANSWERS
=====================================================================

---------------------------------------------------------------
PART ONE: LIFECYCLE QUESTIONS
---------------------------------------------------------------

a) Which methods run when a page opens for the first time?
   The State object is created, then:
   initState() -> didChangeDependencies() -> build().
   initState runs once, didChangeDependencies runs right after it,
   and build draws the screen.

b) Which method runs again after pressing the heart button?
   Only build(). setState() marks the page as "dirty", so Flutter
   calls build() again. initState and didChangeDependencies do NOT
   run again because the State object is kept.

c) Which methods run when leaving a page and going back?
   - Products -> Details (context.push): ProductsPage stays alive
     underneath, so its deactivate/dispose do NOT run. DetailsPage
     runs initState -> didChangeDependencies -> build.
   - Details -> Products (context.pop): DetailsPage runs
     deactivate() -> dispose(). ProductsPage is still alive and
     only runs build() if setState is called (we call it when the
     cart message comes back).
   - Login -> Products (context.goNamed): LoginPage is replaced, so it
     runs deactivate() -> dispose(), and ProductsPage runs
     initState -> didChangeDependencies -> build.
   deactivate() means the widget was removed from the tree (it could
   in theory be re-inserted). dispose() means it is gone for good and
   we must release resources. After dispose the State is never used
   again.

d) Which methods run when resizing the browser window, and why?
   didChangeDependencies() and then build() run on ProductsPage.
   Reason: ProductsPage calls MediaQuery.sizeOf(context), which
   registers the page as a dependent of the inherited MediaQuery
   widget. When the window size changes, MediaQuery gets new data,
   so Flutter notifies every dependent State by calling
   didChangeDependencies(), followed by build().
   (Details/Login do not read MediaQuery, so they are not notified.)

   Note: the exact sequence can vary depending on widget updates,
   navigation, and whether Flutter reuses or removes a widget (for
   example hot reload, extra rebuilds, or a page covered by another
   page). The sequences above are the typical ones.

---------------------------------------------------------------
PART TWO: NAVIGATION QUESTIONS
---------------------------------------------------------------

1) What is the difference between context.go and context.push?
   context.go replaces the current stack with the destination
   location. Example: context.goNamed('products') after Login, so
   LoginPage is removed. context.push adds the new page ON TOP of
   the current one and keeps the old page alive. Example:
   context.push('/details/Laptop/1200') keeps ProductsPage underneath.

2) Why go for Login -> Products and push for Products -> Details?
   go simply navigates to a destination: after logging in we don't
   want the user to return to the login screen. push adds a page to
   the navigation stack and supports returning a result: DetailsPage
   calls context.pop("... added to cart") and ProductsPage receives
   that String from `await context.push<String>(...)`.

3) What is the difference between a path parameter and a query parameter?
   Path parameter: part of the path itself and required to match the
   route, e.g. /details/Laptop/1200 -> name = Laptop, price = 1200,
   read with state.pathParameters['name'] and ['price'].
   Query parameter: optional data after the "?", e.g.
   /products?user=Guest -> username = Guest, read with
   state.uri.queryParameters['user'] (default 'Guest').
   The product name and price are taken from the tapped item in the
   products list (then placed in the URL), and the username comes
   from the query string.
=====================================================================
*/

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/details_page.dart';
import 'pages/login_page.dart';
import 'pages/products_page.dart';

// ---------------------------------------------------------------------
// ACTIVE VERSION: go_router
// ---------------------------------------------------------------------
void main() {
  runApp(const MiniProductCatalogApp());
}

/// Router configuration with the three required routes.
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Route 1: Login  ->  /
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),

    // Route 2: Products  ->  /products?user=Guest
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        // Query parameter (optional, so we give it a default).
        final username = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: username);
      },
    ),

    // Route 3: Details  ->  /details/Laptop/1200
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        // go_router already URL-decodes path parameters
        // (e.g. "Smart%20Watch" -> "Smart Watch"), so we must NOT
        // decode them a second time.
        final name = state.pathParameters['name'] ?? 'Unknown';
        // Path parameters are always Strings, so we parse the price.
        final price = int.tryParse(state.pathParameters['price'] ?? '') ?? 0;
        return DetailsPage(name: name, price: price);
      },
    ),
  ],
);

class MiniProductCatalogApp extends StatelessWidget {
  const MiniProductCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: _router,
    );
  }
}

// =====================================================================
// OLD VERSION (kept for comparison): Navigator + named routes
// =====================================================================
// To use it: comment out the go_router code above (main, _router,
// MiniProductCatalogApp), uncomment the code below, and use the
// Navigator versions of the page calls listed at the bottom.
//
// void main() {
//   runApp(const NavigatorApp());
// }
//
// class NavigatorApp extends StatelessWidget {
//   const NavigatorApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mini Product Catalog',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
//       ),
//       initialRoute: '/',
//       // onGenerateRoute lets us read the route arguments and pass
//       // them to the page constructor.
//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//           case '/':
//             return MaterialPageRoute(builder: (_) => const LoginPage());
//           case '/products':
//             final username = settings.arguments as String? ?? 'Guest';
//             return MaterialPageRoute(
//               builder: (_) => ProductsPage(username: username),
//             );
//         }
//         return null;
//       },
//     );
//   }
// }
//
// --- Navigator versions of the page calls ---------------------------
//
// LoginPage (Login button):
//   Navigator.pushNamed(context, '/products', arguments: 'Guest');
//
// ProductsPage (_openDetails):
//   final result = await Navigator.push<String>(
//     context,
//     MaterialPageRoute(
//       builder: (context) => DetailsPage(
//         name: product["name"],
//         price: product["price"],
//       ),
//     ),
//   );
//   if (!mounted) return;
//   if (result != null) {
//     setState(() {
//       cartMessage = result;
//     });
//   }
//
// DetailsPage (Add to Cart button):
//   Navigator.pop(context, "$name added to cart");
//
// DetailsPage (back button):
//   Navigator.pop(context);
