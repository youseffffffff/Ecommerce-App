import 'package:ecommerce_app/utils/App_Routes.dart';
import 'package:ecommerce_app/utils/app_colors.dart';
import 'package:ecommerce_app/utils/current_user.dart';
import 'package:ecommerce_app/view_models/user/cubit/user_cubit.dart';
import 'package:ecommerce_app/views/widgets/soialMediaBottun_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<UserCubit>(context);

    final passwordController = TextEditingController();
    final emailController = TextEditingController();

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
                'Login Account',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              ),

              Text(
                'Please login with registered account',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(color: AppColors.grey),
              ),

              SizedBox(height: 36),

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

              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forget Password',
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 8),

              BlocConsumer<UserCubit, UserState>(
                bloc: cubit,

                listenWhen: (previous, current) =>
                    current is UserSearchNotFound ||
                    current is UserSearchField ||
                    current is UserSearched,

                listener: (context, state) {
                  if (state is UserSearched) {
                    currentUser = state.user;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Success.'),
                        backgroundColor: AppColors.green,
                      ),
                    );

                    Navigator.of(context).pushReplacementNamed(AppRoutes.home);
                  }
                  if (state is UserSearchNotFound) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Incurrect Password Or Email.'),
                        backgroundColor: AppColors.red,
                      ),
                    );
                    emailController.clear();
                    passwordController.clear();
                  }
                  if (state is UserSearchField) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'An error occurred while loading products.',
                        ),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },

                builder: (context, state) {
                  if (state is UserSearching) {
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
                        cubit.findUser(
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
                        'Login',
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
                          'Have\'t account ?',
                          style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(color: AppColors.grey),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          child: Text(
                            'register',
                            style: Theme.of(context).textTheme.titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.blue,
                                ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'or usig another mathod',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall!.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              SoialMediaBottun(
                icon: Icon(Icons.facebook, color: Colors.blue, size: 36),
                title: 'Facebook',
                event: () {},
              ),

              SizedBox(height: 8),

              SoialMediaBottun(
                icon: Icon(Icons.g_mobiledata, color: Colors.red, size: 36),
                title: 'Google',
                event: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
