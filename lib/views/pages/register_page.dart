import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/view_models/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<AuthCubit>(context);
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    Widget field({
      required String label,
      required TextEditingController controller,
      required Widget icon,
      bool obscure = false,
    }) {
      return TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: controller.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: icon,
                )
              : null,
          prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
          filled: true,
          fillColor: AppColors.grey200,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.grey, width: 1.5),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          labelText: label,
          hintText: 'Enter your $label',
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 64),
              Text(
                'Create Account',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Please register a new account',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: AppColors.grey),
              ),
              SizedBox(height: 36),
              Text(
                'Full Name',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              field(
                label: 'full name',
                controller: nameController,
                icon: Icon(Icons.person),
              ),
              SizedBox(height: 16),
              Text(
                'Email',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              field(
                label: 'email',
                controller: emailController,
                icon: Icon(Icons.email),
              ),
              SizedBox(height: 16),
              Text(
                'Password',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              field(
                label: 'password',
                controller: passwordController,
                icon: Icon(Icons.password),
                obscure: true,
              ),
              SizedBox(height: 16),
              Text(
                'Confirm Password',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              field(
                label: 'confirm password',
                controller: confirmController,
                icon: Icon(Icons.password),
                obscure: true,
              ),
              SizedBox(height: 24),
              BlocConsumer<AuthCubit, AuthState>(
                bloc: cubit,
                listenWhen: (previous, current) =>
                    current is AuthSuccess || current is AuthFailure,
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account created successfully.'),
                        backgroundColor: AppColors.green,
                      ),
                    );
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  }
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },

                builder: (context, state) {
                  if (state is AuthLoading) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.purple,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: AppColors.white,
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (nameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            confirmController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All fields are required.'),
                              backgroundColor: AppColors.red,
                            ),
                          );
                          return;
                        }
                        if (passwordController.text != confirmController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match.'),
                              backgroundColor: AppColors.red,
                            ),
                          );
                          return;
                        }
                        cubit.register(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.purple,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(
                        'Register',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                            ),
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account?',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(color: AppColors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed(AppRoutes.login);
                          },
                          child: Text(
                            'Login',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
