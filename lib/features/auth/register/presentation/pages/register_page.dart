import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wejha/core/error/failures.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_bloc.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_event.dart';
import 'package:wejha/features/auth/register/presentation/bloc/register_state.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_step_one.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_step_two.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_step_three.dart';
import 'package:wejha/features/auth/register/presentation/pages/register_step_four.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) { // Updated to account for the new step
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is VerificationCodeSent) {
            _nextPage();
          } else if (state is CodeVerified) {
            _nextPage();
          } else if (state is RegistrationCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Registration completed successfully'),
                backgroundColor: Colors.green,
              ),
            );
            // Navigate to home or login
            Navigator.of(context).pop();
          } else if (state is VerificationCodeError ||
              state is CodeVerificationError ||
              state is RegistrationError) {
            final failure =
                state is VerificationCodeError
                    ? state.failure
                    : state is CodeVerificationError
                    ? state.failure
                    : (state as RegistrationError).failure;

            // Handle validation errors specifically
            if (failure is ValidationFailure && failure.errors != null) {
              // Extract the first validation error message to display
              String errorMessage = failure.message;
              
              // Check for password validation errors specifically
              if (failure.errors!.containsKey('password')) {
                final passwordErrors = failure.errors!['password'];
                if (passwordErrors is List && passwordErrors.isNotEmpty) {
                  errorMessage = passwordErrors.first;
                }
              } else {
                // If there are other validation errors, get the first one
                final firstErrorField = failure.errors!.keys.first;
                final fieldErrors = failure.errors![firstErrorField];
                if (fieldErrors is List && fieldErrors.isNotEmpty) {
                  errorMessage = fieldErrors.first;
                }
              }
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
            } else {
              // Handle regular errors
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(failure.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              RegisterStepOne(onNext: _nextPage),
              RegisterStepTwo(onNext: _nextPage),
              RegisterStepFour(onNext: _nextPage), // New role selection step
              const RegisterStepThree(), // Personal information step
            ],
          );
        },
      ),
    );
  }
}
