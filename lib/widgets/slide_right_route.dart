import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  SlideRightRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return  SlideTransition(
            position:  Tween<Offset>(
              begin: const Offset(10.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}
