import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:untitled/core/constant/colors.dart';
import 'package:untitled/core/constant/images_paths.dart';
import 'package:untitled/features/auth/presntaoin/pages/login_view.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_button.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_text.dart';
import 'package:untitled/features/auth/presntaoin/widgets/custom_text_form.dart';

class SignupBody extends StatelessWidget {
  const SignupBody({
    super.key,
    required this.isLoading,
    required this.nameController,
    required this.usernameController,
    required this.emailController,
    required this.phoneController,
    required this.passwordController,
    required this.formkey,
    required this.onSignupPressed,
  });

  final bool isLoading;
  final TextEditingController nameController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formkey;
  final VoidCallback onSignupPressed;

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
                  controller: nameController,
                  labelText: 'name',
                  hintlabel: 'Enter your name',
                  onchange: (_) {},
                  prefix: Icon(Icons.person, color: AppColor().primaryColor),
                ),
                const SizedBox(height: 15),
                CustomTextform(
                  ispassword: false,
                  controller: usernameController,
                  labelText: 'username',
                  hintlabel: 'Enter your username',
                  onchange: (_) {},
                  prefix: Icon(Icons.person, color: AppColor().primaryColor),
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
                  ispassword: false,
                  controller: phoneController,
                  labelText: 'phone',
                  hintlabel: 'Enter your phone',
                  onchange: (_) {},
                  prefix: Icon(Icons.phone, color: AppColor().primaryColor),
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
                      text: "you already have an account ?",
                      color: AppColor().primaryColor,
                    ),
                    TextButton(
                      onPressed: () {
                        Get.to(const LoginPage());
                      },
                      child: Customtext(
                        text: "Login",
                        color: AppColor().secondaryColor,
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  text: isLoading ? "Loading..." : "Sign up",
                  ontap: isLoading ? null : onSignupPressed,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
