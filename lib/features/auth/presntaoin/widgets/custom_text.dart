import 'package:flutter/material.dart';

class Customtext extends StatelessWidget {
  Customtext({super.key, required this.text, required this.color ,});

  final String text;
  final Color color ;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(color: color ));
}
