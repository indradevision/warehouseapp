import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OrderTextFormField extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap; // Tambahkan parameter onTap

  const OrderTextFormField({
    Key? key,
    required this.labelText,
    this.hintText,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.onTap, // Inisialisasi onTap di constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: 14),
      readOnly: readOnly,
      keyboardType: keyboardType,
      controller: controller,
      inputFormatters: inputFormatters,
      onTap: onTap, // Gunakan onTap di sini
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.black, fontSize: 14),
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),
      validator: validator,
    );
  }
}
