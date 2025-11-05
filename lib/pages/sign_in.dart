import 'package:flutter/material.dart';
import 'package:grape/pages/sign_up.dart';
import 'package:grape/theme/app_colors_extension.dart';
import 'package:grape/viewmodels/login_viewmodel.dart';
import 'package:provider/provider.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).extension<AppColorsExtension>()!.backgroundColor,
      body: ChangeNotifierProvider(
        create: (_) => LoginViewModel(),
        child: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60),
                    Image.asset('assets/logo/logo.png', height: 120),
                    const SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: primaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    // Email TextField
                    TextField(
                      controller: viewModel.emailController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Theme.of(context).extension<AppColorsExtension>()!.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(Icons.email, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Password TextField
                    TextField(
                      controller: viewModel.passwordController,
                      style: const TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Theme.of(context).extension<AppColorsExtension>()!.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: primaryColor,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.black),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    // Sign In Button
                    ElevatedButton(
                      onPressed: viewModel.signIn,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Error Message
                    if (viewModel.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          border: Border.all(color: Colors.red.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          viewModel.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),
                    // Sign Up Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SignUp()),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}