import 'package:flutter/cupertino.dart';
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
  bool isobs = false;

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
        labelStyle: TextStyle(color: AppColor().secondaryColor),
        hintText: widget.hintlabel,
        hintStyle: TextStyle(
          color: AppColor().primaryColor,
          fontWeight: FontWeight.w200,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColor().primaryColor,
            style: BorderStyle.solid,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: AppColor().primaryColor,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: AppColor().primaryColor),
        ),
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
    if (hidden) {
      return Icon(CupertinoIcons.eye, color: AppColor().primaryColor);
    } else {
      return Icon(CupertinoIcons.eye_slash, color: AppColor().primaryColor);
    }
  }
}
