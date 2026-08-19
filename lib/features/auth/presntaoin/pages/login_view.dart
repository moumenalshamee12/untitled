import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:untitled/core/utils/api_service.dart';
import 'package:untitled/core/utils/error_snackbar.dart';
import 'package:untitled/core/utils/success_snackbar.dart';
import 'package:untitled/features/auth/data/data_source/auth_remote_data_source.dart';
import 'package:untitled/features/auth/data/repo/auth_repp_imp.dart';
import 'package:untitled/features/auth/domain/usecases/login_case.dart';
import 'package:untitled/features/auth/presntaoin/manger/login_cubit/login_cubit.dart';
import 'package:untitled/features/auth/presntaoin/manger/login_cubit/login_states.dart';
import 'package:untitled/features/auth/presntaoin/pages/profile_view.dart';
import 'package:untitled/features/auth/presntaoin/pages/signup_view.dart';
import 'package:untitled/features/auth/presntaoin/widgets/login_body.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        LoginUseCase(
          authRepo: AuthReppImp(
            authRemoteDataSource: AuthRemoteDataSourceimp(
              apiService: ApiService(dio: Dio()),
            ),
          ),
        ),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (formkey.currentState?.validate() ?? false) {
      context.read<LoginCubit>().login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginErrorState) {
          showErrorSnackBar(context, state.error);
        } else if (state is LoginSuccessState) {
          showSuccessSnackBar(context, state.message);
          Get.offAll(const ProfileView());
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoadingState;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            body: LoginBody(
              isLoading: isLoading,
              emailController: emailController,
              passwordController: passwordController,
              formkey: formkey,
              onLoginPressed: _onLoginPressed,
            ),
          ),
        );
      },
    );
  }
}
