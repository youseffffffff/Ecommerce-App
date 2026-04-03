import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:ecommerce_app/view_models/cart/cubit/cart_cubit.dart';
import 'package:ecommerce_app/view_models/home/cubit/Home_cubit.dart';
import 'package:ecommerce_app/views/pages/cart_page.dart';
import 'package:ecommerce_app/views/pages/favorite_page.dart';
import 'package:ecommerce_app/views/pages/home_page.dart';
import 'package:ecommerce_app/views/pages/profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  final _bottomNavbarController = PersistentTabController();

  List<Widget> _buildScreens() {
    return [
      BlocProvider(
        create: (context) {
          final cubit = HomeCubit();
          cubit.getHomeContent();
          return cubit;
        },
        child: const HomePage(),
      ),
      BlocProvider(
        create: (context) {
          final cubit = CartCubit();
          cubit.getCartItems();
          return cubit;
        },
        child: const CartPage(),
      ),

      FavoritePage(),
      ProfilePage(),
    ];
  }

  late int index;

  initState() {
    super.initState();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: CachedNetworkImageProvider(
                'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=60',
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentUser.fullName.split(' ')[0],
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                ),

                Text(
                  'Welcome Back,',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (index == 0) ...[
            Icon(Icons.search),
            SizedBox(width: 10),
            Icon(Icons.notifications),
          ],
          if (index == 1) ...[Icon(Icons.delete_outline), SizedBox(width: 10)],
        ],
      ),

      body: PersistentTabView(
        onTabChanged: (value) => () {
          setState(() {
            index = value;
          });
        },
        stateManagement: false,

        controller: _bottomNavbarController,
        tabs: [
          PersistentTabConfig(
            screen: _buildScreens()[0],
            item: ItemConfig(
              icon: const Icon(CupertinoIcons.home),
              title: ("Home"),
              activeForegroundColor: AppColors.purple,
            ),
          ),
          PersistentTabConfig(
            screen: _buildScreens()[1],
            item: ItemConfig(
              icon: const Icon(CupertinoIcons.shopping_cart),
              title: ("Cart"),
              activeForegroundColor: AppColors.purple,
            ),
          ),
          PersistentTabConfig(
            screen: _buildScreens()[2],
            item: ItemConfig(
              icon: const Icon(Icons.favorite_border),
              title: ("Favorites"),
              activeForegroundColor: AppColors.purple,
            ),
          ),
          PersistentTabConfig(
            screen: _buildScreens()[3],
            item: ItemConfig(
              icon: const Icon(CupertinoIcons.profile_circled),
              title: ("Profile"),
              activeForegroundColor: AppColors.purple,
            ),
          ),
        ],
        navBarBuilder: (navbarConfig) =>
            Style1BottomNavBar(navBarConfig: navbarConfig),

        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,

        screenTransitionAnimation: const ScreenTransitionAnimation(
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
