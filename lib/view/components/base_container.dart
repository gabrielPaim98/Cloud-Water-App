import 'package:cloud_water/util/colors.dart';
import 'package:flutter/material.dart';

class BaseContainer extends StatelessWidget {
  BaseContainer({required this.child, this.padding = 16}) : super();
  final Widget child;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: COMPLETE_WHITE,
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: child,
    );
  }
}
