import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/config/theme/app_theme.dart';

class CustomCardsType1 extends StatelessWidget {
  const CustomCardsType1({
    super.key,
    this.width,
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
        color: AppColors.piedra,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.cafeNoir),
      ),
      child: child,
    );
  }
}
