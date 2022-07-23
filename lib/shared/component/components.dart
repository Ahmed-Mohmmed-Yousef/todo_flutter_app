import 'dart:ffi';

import 'package:flutter/material.dart';

class DefualtTextField extends StatelessWidget {
  const DefualtTextField({
    Key? key,
    required this.controller,
    required this.title,
    required this.icon,
    required this.validator,
    this.readOnly = false,
    this.onTap,
  }) : super(key: key);

  final TextEditingController controller;
  final String title;
  final IconData icon;
  final FormFieldValidator<String>? validator;
  final void Function()? onTap;
  final bool readOnly;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(icon),
        border: const OutlineInputBorder(),
        label: Text(title),
      ),
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
    );
  }
}
