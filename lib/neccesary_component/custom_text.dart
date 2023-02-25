
import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  const CustomText({Key? key, required this.text, this.fontSize = 16, this.fontWeight = FontWeight.w500, this.color = Colors.black}) : super(key: key);

  @override
  State<CustomText> createState() => _CustomTextState();
}

class _CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        color: widget.color,
        fontSize: widget.fontSize,
        fontWeight: widget.fontWeight,
      ),
    );
  }
}
