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
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            // Profile Picture
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'lib/assets/images/profile_placeholder.png',
              ), // Change to your asset
              backgroundColor: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            // Name
            Text(
              'User Name', // Replace with actual user name if available
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            // Email
            Text(
              'user@email.com', // Replace with actual user email if available
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            // Profile Details Section (add more fields if needed)
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Profile Info',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    // Add more profile fields here
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Logout Button (logic untouched)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: BlocConsumer<AuthCubit, AuthState>(
                bloc: authCubit,
                listenWhen: (previous, current) =>
                    current is AuthFailure || current is AuthLoggedOut,
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Logout failed')),
                    );
                  } else if (state is AuthLoggedOut) {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pushNamedAndRemoveUntil(
                      AppRoutes.login,
                      (route) => false,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AuthLoading) {
                    return const CircularProgressIndicator();
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await authCubit.logout();
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
