import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.ontap});

  final String text;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: AppColor().secondaryColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: AppColor().primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
