import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String value;
  final Function() onClick;
  const SubmitButton({super.key, required this.value, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onClick,
        child: Text(value),
      ),
    );
  }
}
