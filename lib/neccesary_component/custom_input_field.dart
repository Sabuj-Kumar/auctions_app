
import 'package:ebay_ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final TextEditingController controller;
  final bool inputAction;
  final String? Function(String?)? validate;
  final bool suffixIcon;
  const CustomInputField({Key? key, required this.controller,this.inputAction = false, this.validate,this.suffixIcon = false}) : super(key: key);

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool obscure = false;

  @override
  void initState() {
    super.initState();
    obscure = widget.suffixIcon;
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      cursorColor: purpleColor,
      textInputAction: widget.inputAction?TextInputAction.done:TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: purpleColor
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: purpleColor
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: purpleColor
            )
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: purpleColor
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: purpleColor
            )
        ),
        suffixIcon: widget.suffixIcon?IconButton(onPressed: (){
          setState(() {
            obscure = !obscure;
          });
        }, icon: obscure?const Icon(Icons.visibility_off):const Icon(Icons.visibility)):null
      ),
      validator: widget.validate,
      obscuringCharacter: '*',
      obscureText: obscure,
    );
  }
}
