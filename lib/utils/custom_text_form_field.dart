import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final int maxLines;
  final int minLines;
  final String labelText;
  final String hintText;
  final bool alignLabelWithHint;
  final double borderRadius;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color errorBorderColor;
  final Color fillColor;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final int maxLength;
  final TextCapitalization textCapitalization;
  final EdgeInsetsGeometry contentPadding; // Add contentPadding as a parameter

  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.validator,
    this.maxLines = 1,
    this.minLines = 1,
    required this.labelText,
    required this.hintText,
    this.alignLabelWithHint = false,
    this.borderRadius = 12.0,
    this.enabledBorderColor = const Color(0xFFE5E7EB),
    this.focusedBorderColor = const Color(0xFF1565C0),
    required this.errorBorderColor,
    this.fillColor = const Color(0xFFF9FAFB),
    required this.labelStyle,
    required this.hintStyle,
    required this.textStyle,
    this.maxLength = 1000,
    this.textCapitalization = TextCapitalization.sentences,
    this.contentPadding = const EdgeInsets.all(16.0), // Provide a default value
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        alignLabelWithHint: alignLabelWithHint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius * 0.9),
          borderSide: BorderSide(
            color: enabledBorderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius * 0.9),
          borderSide: BorderSide(
            color: enabledBorderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius * 0.9),
          borderSide: BorderSide(
            color: focusedBorderColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius * 0.9),
          borderSide: BorderSide(
            color: errorBorderColor,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius * 0.9),
          borderSide: BorderSide(
            color: errorBorderColor,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: contentPadding, // Use the contentPadding parameter
        labelStyle: labelStyle,
        hintStyle: hintStyle,
      ),
      style: textStyle,
      textCapitalization: textCapitalization,
      maxLength: maxLength,
    );
  }
}
