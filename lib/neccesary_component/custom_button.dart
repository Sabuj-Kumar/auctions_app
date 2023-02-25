
import 'package:ebay_ecommerce/neccesary_component/custom_text.dart';
import 'package:ebay_ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String buttonText;
  final Color buttonColor;
  final VoidCallback onPressed;
  const CustomButton({Key? key, required this.buttonText, this.buttonColor = Colors.cyan, required this.onPressed}) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.buttonColor,
            minimumSize: const Size(double.infinity,50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            )
          ),
          child: CustomText(text: widget.buttonText,color: whiteColor,fontSize: 23,),
      ),
    );
  }
}
