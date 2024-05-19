import 'package:flutter/material.dart';

class SupersetDivider extends StatelessWidget {
  final bool isSuperset;
  final Function() onUnlinkClick;
  const SupersetDivider({
    super.key,
    required this.isSuperset,
    required this.onUnlinkClick,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: isSuperset ? 48 : 16,
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: isSuperset ? 48 : 24,
              child: const Divider(),
            ),
            AnimatedScale(
              scale: isSuperset ? 1 : 0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.elasticInOut,
              child: Center(
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: EdgeInsets.zero,
                  child: InkWell(
                    onTap: onUnlinkClick,
                    borderRadius: BorderRadius.circular(24),
                    child: Icon(
                      Icons.link_rounded,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),

                    /*tooltip: AppLocalizations.of(context)!.delete_superset,
                    onPressed: onUnlinkClick,*/
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
