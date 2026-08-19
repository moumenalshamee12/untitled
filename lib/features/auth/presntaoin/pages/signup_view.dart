import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/core/utils/success_snackbar.dart';
import 'package:untitled/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:untitled/features/auth/data/repo/auth_repp_imp.dart';
import 'package:untitled/features/auth/domain/usecases/signup_case.dart';
import 'package:untitled/features/auth/presntaoin/manger/signup_cubit/signup_cubit.dart';
import 'package:untitled/features/auth/presntaoin/manger/signup_cubit/signup_states.dart';
import 'package:untitled/features/auth/presntaoin/pages/login_view.dart';
import 'package:untitled/features/auth/presntaoin/widgets/signup_body.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignupCubit(
        SignupUseCase(
          authRepo: AuthReppImp(
            authRemoteDataSource: AuthRemoteDataSourceimp(
              apiService: ApiService(dio: Dio()),
            ),
          ),
        ),
      ),
      child: const SignupView(),
    );
  }
}

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onSignupPressed() {
    if (formkey.currentState?.validate() ?? false) {
      context.read<SignupCubit>().signup(
        usernameController.text.trim(),
        passwordController.text.trim(),
        nameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignupCubit, SignupStates>(
      listener: (context, state) {
        if (state is SignupErrorState) {
          showErrorSnackBar(context, state.error);
        } else if (state is SignupSuccessState) {
          showSuccessSnackBar(context, state.message);
          Get.offAll(const LoginPage());
        }
      },
      builder: (context, state) {
        final isLoading = state is SignupLoadingState;
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: SignupBody(
              isLoading: isLoading,
              nameController: nameController,
              usernameController: usernameController,
              emailController: emailController,
              phoneController: phoneController,
              passwordController: passwordController,
              formkey: formkey,
              onSignupPressed: _onSignupPressed,
            ),
          ),
        );
      },
    );
  }
}
