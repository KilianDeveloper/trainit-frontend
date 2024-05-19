import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  final String name;
  final String content;
  const HelpPage({
    super.key,
    required this.name,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        const SizedBox(height: 12),
        Text(content),
      ],
    );
  }
}
