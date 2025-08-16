import 'package:flutter/material.dart';

class CustomCards extends StatelessWidget {
  const CustomCards({
    super.key,
    this.width ,
    required this.height,
    required this.child,
  });

  final double? width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey),
      ),
      child: child,
    );
  }
}
