# Mini Product Catalog

A responsive Flutter application that demonstrates widget lifecycle methods, product browsing, and navigation using **go_router**.

## Features

- **Three screens:** Login, Products, and Product Details.
- **Responsive product layout:**
  - List view when the screen width is less than 600 pixels.
  - Grid view with two columns when the screen width is 600 pixels or wider.
- **Favorites counter:** Tap a heart button to increase the favorites count.
- **Product details:** Select a product to view its name and price.
- **Add to Cart:** Return a message to the Products screen when a product is added.
- **Widget lifecycle logging:** Each page logs `initState`, `didChangeDependencies`, `build`, `deactivate`, and `dispose`.
- **Responsive width display:** The Products screen displays the current screen width.
- **Navigation practice:** The active implementation uses `go_router`; the `Navigator` version is retained as commented-out code for comparison.
- **Helper widgets:** Uses `ProductsListView` and `ProductsGridView` from `product_widgets.dart`.

## Technologies

- Flutter
- Dart
- Material 3
- `go_router`

## Project Structure

```text
mini_product_catalog/
├── lib/
│   ├── main.dart
│   ├── product_widgets.dart
│   └── pages/
│       ├── login_page.dart
│       ├── products_page.dart
│       └── details_page.dart
├── pubspec.yaml
└── README.md
```

## Getting Started

### Prerequisites

Install Flutter and configure an emulator or browser for running Flutter apps. Verify the installation with:

```bash
flutter doctor
```

### Install Dependencies

From the project directory, run:

```bash
flutter pub get
```

If `go_router` has not yet been added to `pubspec.yaml`, add it with:

```bash
flutter pub add go_router
```

### Run the App

Run the application in Chrome:

```bash
flutter run -d chrome
```

You can also run it on a configured Android emulator or device.

### Analyze the Code

```bash
flutter analyze
```

## How to Use

1. Open the app and press **Login** to continue as `Guest`.
2. On the Products screen, check the welcome message, favorites counter, and screen width.
3. Press a heart icon to increase the favorites counter.
4. Resize the browser window:
   - Below 600 pixels wide, products should appear in a list.
   - At 600 pixels wide or above, products should appear in a two-column grid.
5. Select a product to open its Details screen.
6. Press **Add to Cart** to return to the Products screen and display the result message.
7. Observe the debug console to review widget lifecycle messages.

## Navigation

The active `go_router` routes are:

| Screen | Route | Purpose |
|---|---|---|
| Login | `/` | Entry screen |
| Products | `/products?user=Guest` | Products screen with a username query parameter |
| Product Details | `/details/:name/:price` | Details screen using product name and price path parameters |

The intended navigation flow is:

- Login → Products: `context.goNamed(...)`
- Products → Details: `context.push(...)`
- Details → Products: `context.pop(...)`, returning the cart message

The project also retains the `Navigator` implementation as commented-out code for comparison, as required by the assignment.

## Widget Lifecycle

Each page logs the following lifecycle methods to the debug console:

- `initState()`
- `didChangeDependencies()`
- `build()`
- `deactivate()`
- `dispose()`

On the Products screen, `MediaQuery.sizeOf(context)` is used to read the available screen size. The responsive layout should update when the browser width changes.

## Assignment Notes

- All three pages are implemented as `StatefulWidget`s.
- The favorites counter is updated with `setState`.
- Product display uses the supplied helper widgets.
- The active navigation flow uses `go_router`.
- The `Navigator` implementation should remain commented out.
- Capture a debug-console screenshot showing lifecycle messages before submitting.

## Author

Created as a Flutter learning project for practicing widget lifecycle, responsive layouts, callbacks, and navigation.
