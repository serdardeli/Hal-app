import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyTopBar extends StatelessWidget {
  final String? text;

  final TextStyle? style;
  final String? uniqueHeroTag;
  final Widget child;

  MyTopBar({
    this.text,
    this.style,
    this.uniqueHeroTag,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            text ?? "null",
            style: style,
          ),
        ),
        body: child,
      );
    } else {
      return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: "uniqueHeroTag",
          transitionBetweenRoutes: false,
          middle: Text(
            text ?? "nulll",
            style: style,
          ),
        ),
        child: child,
      );
    }
  }
}
