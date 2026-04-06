import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/view_models/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Scaffold(
      body: Center(
        child: BlocConsumer<AuthCubit, AuthState>(
          bloc: authCubit,

          listenWhen: (previous, current) =>
              current is AuthFailure || current is AuthLoggedOut,
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Logout failed')));
            } else if (state is AuthLoggedOut) {
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            }
          },

          builder: (context, state) {
            if (state is AuthLoading) {
              return CircularProgressIndicator();
            }
            return ElevatedButton(
              onPressed: () async {
                await authCubit.logout();
              },
              child: Text('Logout'),
            );
          },
        ),
      ),
    );
  }
}
