import 'package:flutter/material.dart';

Widget buildListTransition(dynamic id, Animation<double> animation,
    {required Widget child}) {
  return SizeTransition(
    key: ValueKey(id),
    sizeFactor: Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
      reverseCurve: Curves.easeIn,
    )),
    child: FadeTransition(
      key: ValueKey(id),
      opacity: Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeIn,
        reverseCurve: Curves.easeIn,
      )),
      child: child,
    ),
  );
}
