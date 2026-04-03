import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/utils/app_colors.dart';

import 'package:ecommerce_app/view_models/home/cubit/Home_cubit.dart';
import 'package:ecommerce_app/views/widgets/category_view_Bar_Widget.dart';
import 'package:ecommerce_app/views/widgets/home_vew_bar_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    //final homeCubit = BlocProvider.of<HomeCubit>(context);

    //final homeCubit = context.read<HomeCubit>();

    final homeCubit = BlocProvider.of<HomeCubit>(context);

    return Scaffold(
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: homeCubit,
        buildWhen: (previous, current) =>
            current is HomeLoading ||
            current is HomeLoaded ||
            current is HomeError,

        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomeError) {
            return Center(child: Text(state.message));
          } else if (state is HomeLoaded) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),

                child: Column(
                  children: [
                    SizedBox(height: 15),

                    TabBar(
                      unselectedLabelColor: AppColors.grey,
                      labelColor: AppColors.black,
                      tabs: [
                        Tab(text: 'Home'),
                        Tab(text: 'Categories'),
                      ],
                      controller: _tabController,
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          HomeViewBar(products: state.products),
                          CategoryViewBar(),
                        ],
                        controller: _tabController,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}
