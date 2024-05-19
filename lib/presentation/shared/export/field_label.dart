import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  final String title;
  const FieldLabel(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium,
    );
  }
}
