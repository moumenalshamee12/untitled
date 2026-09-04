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
      padding: EdgeInsets.only(
        left: 20,
        top: 24,
        right: 20,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Image.asset(AppImages().logo, height: 100),
                        const SizedBox(height: 12),
                        const Text(
                          'مرحباً بعودتك',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'سجّل الدخول لإدارة طلباتك',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextform(
                    ispassword: false,
                    controller: emailController,
                    labelText: 'البريد الإلكتروني',
                    hintlabel: 'أدخل بريدك الإلكتروني',
                    onchange: (_) {},
                    prefix: Icon(Icons.email, color: AppColor().primaryColor),
                  ),
                  const SizedBox(height: 15),
                  CustomTextform(
                    ispassword: true,
                    controller: passwordController,
                    labelText: 'كلمة المرور',
                    hintlabel: 'أدخل كلمة المرور',
                    onchange: (_) {},
                    prefix: Icon(
                      Icons.security,
                      color: AppColor().primaryColor,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Customtext(
                        text: 'ليس لديك حساب؟',
                        color: AppColor().primaryColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(const SignupPage());
                        },
                        child: Customtext(
                          text: 'إنشاء حساب',
                          color: AppColor().secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  CustomButton(
                    text: isLoading ? 'جاري الدخول...' : 'تسجيل الدخول',
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
      ),
    );
  }
}
