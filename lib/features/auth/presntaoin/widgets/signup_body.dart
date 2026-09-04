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
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      color: AppColor().primaryColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Image.asset(AppImages().logo, height: 82),
                        const SizedBox(height: 10),
                        const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'ابدأ رحلتك مع منصتنا',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomTextform(
                    ispassword: false,
                    controller: nameController,
                    labelText: 'الاسم الكامل',
                    hintlabel: 'أدخل اسمك الكامل',
                    onchange: (_) {},
                    prefix: Icon(Icons.person, color: AppColor().primaryColor),
                  ),
                  const SizedBox(height: 15),
                  CustomTextform(
                    ispassword: false,
                    controller: usernameController,
                    labelText: 'اسم المستخدم',
                    hintlabel: 'أدخل اسم المستخدم',
                    onchange: (_) {},
                    prefix: Icon(Icons.person, color: AppColor().primaryColor),
                  ),
                  const SizedBox(height: 15),
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
                    ispassword: false,
                    controller: phoneController,
                    labelText: 'رقم الهاتف',
                    hintlabel: 'أدخل رقم الهاتف',
                    onchange: (_) {},
                    prefix: Icon(Icons.phone, color: AppColor().primaryColor),
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
                        text: 'لديك حساب بالفعل؟',
                        color: AppColor().primaryColor,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(const LoginPage());
                        },
                        child: Customtext(
                          text: 'تسجيل الدخول',
                          color: AppColor().secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  CustomButton(
                    text: isLoading ? 'جاري إنشاء الحساب...' : 'إنشاء الحساب',
                    ontap: isLoading ? null : onSignupPressed,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
