import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/constant/images_paths.dart';
import 'package:untitled/features/auth/presntaoin/pages/signup_view.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_button.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_text.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_text_form.dart';

class LoginBody extends StatelessWidget {
  const LoginBody({
    super.key,
    required this.isLoading,
    required this.emailController,
    required this.passwordController,
    required this.formkey,
    required this.onLoginPressed,
  });

  final bool isLoading;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formkey;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                const SizedBox(height: 25),
                Container(
                  height: 200,
                  width: 200,
                  child: Image.asset(AppImages().logo),
                ),
                const SizedBox(height: 15),
                CustomTextform(
                  ispassword: false,
                  controller: emailController,
                  labelText: 'email',
                  hintlabel: 'Enter your Email',
                  onchange: (_) {},
                  prefix: Icon(Icons.email, color: AppColor().primaryColor),
                ),
                const SizedBox(height: 15),
                CustomTextform(
                  ispassword: true,
                  controller: passwordController,
                  labelText: 'password',
                  hintlabel: 'Enter your Password',
                  onchange: (_) {},
                  prefix: Icon(Icons.security, color: AppColor().primaryColor),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Customtext(
                      text: "you dont have an account ?",
                      color: AppColor().primaryColor,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(const SignupPage());
                      },
                      child: Customtext(
                        text: "sign up",
                        color: AppColor().secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: isLoading ? "Loading..." : "Login",
                  ontap: isLoading ? null : onLoginPressed,
                ),
                if (isLoading) ...[
                  const SizedBox(height: 16),
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
