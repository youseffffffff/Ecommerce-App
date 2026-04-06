import 'package:ecommerce_app/utils/App_Router.dart';
import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/view_models/auth/auth_cubit.dart';
import 'package:ecommerce_app/view_models/user/cubit/user_cubit.dart';
import 'package:ecommerce_app/views/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/view_models/checkout/cubit/checkout_cubit.dart';
import 'package:ecommerce_app/view_models/home/cubit/Home_cubit.dart';
import 'package:ecommerce_app/view_models/product/cubit/product_cubit.dart';
import 'package:ecommerce_app/view_models/cart/cubit/cart_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const DebugApp());
}

class DebugApp extends StatelessWidget {
  const DebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..checkAuth(),
      child: Builder(
        builder: (context) {
          final authCubit = BlocProvider.of<AuthCubit>(context);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => UserCubit()),
              BlocProvider(create: (_) => HomeCubit()),
              BlocProvider(create: (_) => ProductCubit()),
              BlocProvider(create: (_) => CheckoutCubit()),
              BlocProvider(create: (_) => CartCubit()),
            ],

            child: BlocBuilder<AuthCubit, AuthState>(
              bloc: authCubit,

              buildWhen: (previous, current) =>
                  current is AuthSuccess || current is AuthInitial,
              builder: (context, state) {
                return MaterialApp(
                  theme: ThemeData(),
                  //home: const BottomNavbar(),
                  initialRoute: state is AuthSuccess
                      ? AppRoutes.home
                      : AppRoutes.login,
                  onGenerateRoute: AppRouters.onGenerateRoute,
                  debugShowCheckedModeBanner: false,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
