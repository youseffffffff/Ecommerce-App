#Ecommerce App
A full-featured ecommerce application built with Flutter, supporting Android, iOS, web, Windows, macOS, and Linux.

Features
User authentication and registration
Product catalog with categories and carousel images
Shopping cart and checkout flow
Payment methods management
Address management for shipping
User profile and favorites
State management using Cubit/Bloc
Firebase integration for backend services
Project Structure
models — Data models (User, Product, Cart, Address, etc.)
view_models — State management (Cubits for user, cart, checkout, etc.)
pages — Main app pages (Home, Login, Register, Product Details, Checkout, etc.)
widgets — Reusable UI components (Product item, Payment method, Address, etc.)
services — Service classes (e.g., authentication)
utils — Utilities (routing, colors, helpers)
Getting Started
Clone the repository.
Run flutter pub get to install dependencies.
Configure Firebase using flutterfire configure.
Run the app on your preferred platform: flutter run.
Dependencies
firebase_core and other Firebase packages
State management: flutter_bloc or bloc
UI: Material Design widgets
Contributing
Feel free to open issues or submit pull requests for improvements and new features.