import 'package:flutter/material.dart';

class FormGroup extends StatelessWidget {
  const FormGroup(
    this.title, {
    super.key,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        Card(
          margin: const EdgeInsets.all(0),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: Column(
              children: _buildChildren(),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren() {
    final List<Widget> uiChildren = [];
    for (int i = 0; i < children.length; i++) {
      final child = children[i];
      uiChildren.addAll([
        child,
        if (i != children.length - 1) const SizedBox(height: 8),
      ]);
    }
    return uiChildren;
  }
}

class FormItem extends StatelessWidget {
  const FormItem({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const Spacer(),
        content,
      ],
    );
  }
}
