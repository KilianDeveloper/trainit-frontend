import 'package:flutter/material.dart';
import 'package:trainit/presentation/shared/export/help_page.dart';

class HelpPageManager extends StatefulWidget {
  final String title;
  final List<HelpPage> pages;
  const HelpPageManager({super.key, required this.pages, required this.title});

  @override
  State<HelpPageManager> createState() => _HelpPageManagerState();
}

class _HelpPageManagerState extends State<HelpPageManager> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          IndexedStack(
            index: index,
            children: widget.pages,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (index > 0) {
                      setState(() {
                        index--;
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Text("${index + 1}/${widget.pages.length}"),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  setState(() {
                    if (index < widget.pages.length - 1) {
                      setState(() {
                        index++;
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.arrow_forward_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
