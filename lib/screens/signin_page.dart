import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_wheelz/bloc/sign_in_cubit.dart';
import 'package:mini_wheelz/core/colors.dart';
import 'package:mini_wheelz/widgets/enhanced_ui_components.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInCubit(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: EnhancedUIComponents.gradientAppBar(title: 'Admin Login'),
        body: Center(
          child: SingleChildScrollView(
            child: EnhancedUIComponents.enhancedCard(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In to Admin',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Text(
                            state.error!,
                            style: TextStyle(
                              color: errorColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      EnhancedUIComponents.enhancedInputField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      EnhancedUIComponents.enhancedInputField(
                        controller: _passwordController,
                        label: 'Password',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      state.isLoading
                          ? EnhancedUIComponents.loadingWidget(
                              message: 'Signing in...',
                            )
                          : EnhancedUIComponents.primaryButton(
                              text: 'Sign In',
                              icon: Icons.login,
                              onPressed: () {
                                context.read<SignInCubit>().signIn(
                                  _emailController.text,
                                  _passwordController.text,
                                );
                              },
                              width: double.infinity,
                              height: 50,

                     ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
