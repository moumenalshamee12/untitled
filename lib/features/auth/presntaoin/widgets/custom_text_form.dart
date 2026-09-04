import 'package:flutter/material.dart';
import 'package:untitled/core/constant/colors.dart';

class CustomTextform extends StatefulWidget {
  final String labelText;
  final String hintlabel;
  final IconButton? suffixicon;
  final Icon? prefix;
  final ValueChanged<String> onchange;
  final TextEditingController controller;
  final bool ispassword;

  CustomTextform({
    super.key,
    required this.labelText,
    required this.hintlabel,
    this.suffixicon,
    required this.onchange,
    this.prefix,
    required this.controller,
    required this.ispassword,
  });

  @override
  State<CustomTextform> createState() => _CustomTextformState();
}

class _CustomTextformState extends State<CustomTextform> {
  bool isobs = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        suffixIcon: widget.ispassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isobs = !isobs;
                  });
                },
                icon: returnicon(isobs),
              )
            : null,

        prefixIcon: widget.prefix,
        labelText: widget.labelText,
        hintText: widget.hintlabel,
      ),
      controller: widget.controller,
      cursorColor: AppColor().primaryColor,
      obscureText: widget.ispassword ? isobs : false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please enter your ${widget.labelText}';
        }
        return null;
      },
      onChanged: widget.onchange,
    );
  }

  Icon returnicon(bool hidden) {
    return Icon(
      hidden ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      color: AppColor().primaryColor,
    );
  }
}
