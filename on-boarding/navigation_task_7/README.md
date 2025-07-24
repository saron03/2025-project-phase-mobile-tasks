# Flutter UI Task - [Your Name]

A simple E-commerce mobile application built with Flutter that allows users to create, view, update, and delete products. The project demonstrates navigation, named routes,data passing between screens, smooth animations, and proper back-navigation handling.

## Features

- Home Screen: Displays a list of all available products.
- Add/Edit Product Screen: Allows users to add new products or edit existing ones (title & description input).
- Product Details Screen: Displays detailed information about a selected product.
- Navigation: Uses named routes for navigation between screens.
- Passing Data Between Screens: Products are passed between screens when adding, editing, or viewing details.
- Smooth Navigation Animations: Custom slide transitions between screens.
- Back Navigation Handling: Proper back-button behavior when navigating from Add/Edit screens.

# Screens

1. Home Page – View list of products and navigate to Add or Details page.

2. Add/Edit Product Page – Create or update a product.

3. Details Page – View and manage an individual product.

4. Search Page – Search a specific product.

## Project Structure

```
lib/
│
├── models/
│   ├── product.dart
│   └── product_repository.dart
│
├── add_product.dart
├── details_page.dart
├── search_page.dart
└── app.dart
```

## Getting Started

### Prerequisites

- Flutter SDK installed.

- A connected device or emulator to run the app.

### How to Run

1. Clone the repository:

```
git clone git@github.com:saron03/2025-project-phase-mobile-tasks.git
```

2. Navigate to the project directory:

```
cd on-boarding/
cd navigation_task_7/
```

3. Get dependencies:

```
flutter pub get
```

4. Run the app:
```
flutter run
```

## Navigation & Routing

- Named Routes:

```
Navigator.pushNamed(context, '/addProduct');
Navigator.pushNamed(context, '/details', arguments: product);
.....
```

- Custom Animations: Implemented using PageRouteBuilder for smooth slide transitions.
