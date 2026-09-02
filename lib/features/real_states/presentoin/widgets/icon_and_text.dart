import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';

class IconAndText extends StatelessWidget {
  final String text;
  final IconData icon;
  const IconAndText({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColor().secondaryColor),
        Expanded(
          child: Text(
            text,

            maxLines: 3,
            textAlign: TextAlign.start,

            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }
}
