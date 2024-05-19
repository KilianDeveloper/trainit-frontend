import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CenterSvg extends StatelessWidget {
  final String path;
  final int flex;
  const CenterSvg({super.key, required this.path, this.flex = 2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
            flex: flex,
            child: LayoutBuilder(
              builder: (context, constraint) => SvgPicture.asset(
                path,
                width: constraint.maxWidth,
                height: constraint.maxWidth,
              ),
            )),
        const Spacer(),
      ],
    );
  }
}
