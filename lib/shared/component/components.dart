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

 Widget buildTaskItem(Map model) {
    return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text(
            model['time'],
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:  [
            Text(
              model['title'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              model['date'],
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        )
      ],
    ),
  );
  }
