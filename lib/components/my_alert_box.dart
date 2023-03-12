import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  MyAlertBox(this.controller, this.onSave, this.onCancel);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Colors.black,
          child: const Text(
            'Save',
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.black,
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
