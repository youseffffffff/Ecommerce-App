import 'package:ecommerce_app/models/cart.items.model.dart';
import 'package:ecommerce_app/models/product_items_model.dart';
import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:ecommerce_app/view_models/home/cubit/Home_cubit.dart';
import 'package:ecommerce_app/view_models/product/cubit/product_cubit.dart';
import 'package:ecommerce_app/view_models/user/cubit/user_cubit.dart';
import 'package:ecommerce_app/views/pages/PaymentMethod_page.dart';
import 'package:ecommerce_app/views/pages/Product_Details_page.dart';
import 'package:ecommerce_app/views/pages/Main_page.dart';
import 'package:ecommerce_app/views/pages/addrees_page.dart';
import 'package:ecommerce_app/views/pages/checkout_page.dart';
import 'package:ecommerce_app/views/pages/login_page.dart';
import 'package:ecommerce_app/views/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouters {
  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UserCubit(),
            child: const LoginPage(),
          ),
          settings: routeSettings,
        );
        break;

      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UserCubit(),
            child: const Register(),
          ),
          settings: routeSettings,
        );
        break;

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(),
            child: const BottomNavbar(),
          ),
          settings: routeSettings,
        );
        break;

      case AppRoutes.productDetails:
        int id = routeSettings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ProductCubit()..loadProductDetails(id),
            child: ProductDetails(),
          ),
          settings: routeSettings,
        );
        break;

      case AppRoutes.checkout:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CheckoutCubit()..loadCheckout(),
            child: CheckoutWidget(),
          ),
          settings: routeSettings,
        );
        break;

      case AppRoutes.paymentMethod:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CheckoutCubit()..loadPaymentMethod(),
            child: PaymentMethodPage(),
          ),
          settings: routeSettings,
        );
        break;

      case AppRoutes.address:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CheckoutCubit()..loadAddress(),
            child: AddressPage(),
          ),
          settings: routeSettings,
        );
        break;

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
          settings: routeSettings,
        );
    }
  }
}
