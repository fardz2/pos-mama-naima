import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final String label;
  final String? hintText;
  final bool obscureText;
  final FontWeight? fontWeight;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? initialValue;
  final bool? enabled;
  final Widget? suffix;

  const TextFieldCustom(
      {super.key,
      required this.label,
      this.hintText,
      this.controller,
      required this.obscureText,
      this.suffixIcon,
      this.validator,
      this.keyboardType,
      this.fontWeight,
      this.initialValue,
      this.enabled,
      this.onChanged,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 16, fontWeight: fontWeight ?? FontWeight.normal),
        ),
        const SizedBox(
          height: 8,
        ),
        TextFormField(
          enabled: enabled,
          initialValue: initialValue,
          validator: validator,
          obscureText: obscureText,
          controller: controller,
          keyboardType: keyboardType ?? TextInputType.text,
          onChanged: onChanged,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            suffix: suffix,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}
