import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/style.dart';

class ContentPage extends StatelessWidget {
  final String? title;
  final List<Widget>? appBarActions;
  final Widget content;
  final Widget? floatingActionButton;

  const ContentPage({
    super.key,
    this.title,
    required this.content,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                if (title != null)
                  AppBar(
                    title: Text(title!),
                    actions: appBarActions,
                  ),
                Expanded(
                  child: Padding(
                    padding: screenPadding,
                    child: content,
                  ),
                )
              ],
            ),
            if (floatingActionButton != null)
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: floatingActionButton,
                ),
              )
          ],
        ),
      ),
    );
  }
}

class SliverContentPage extends StatelessWidget {
  final Widget sliver;
  final Widget appBar;
  final ScrollController controller;
  const SliverContentPage({
    super.key,
    required this.sliver,
    required this.appBar,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          appBar,
          SliverPadding(
            padding:
                screenPadding.add(const EdgeInsets.symmetric(vertical: 24)),
            sliver: sliver,
          ),
        ],
      ),
    );
  }
}
