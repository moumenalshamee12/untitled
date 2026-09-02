import 'package:flutter/material.dart';

class Customtext extends StatelessWidget {
  Customtext({
    super.key,
    required this.text,
    required this.color,
    this.weight,
    this.size,
  });

  final String text;
  final Color color;
  final FontWeight? weight;
  final double? size;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(color: color, fontWeight: weight, fontSize: size),
  );
}
