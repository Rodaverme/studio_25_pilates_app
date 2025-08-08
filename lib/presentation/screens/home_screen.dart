import 'package:flutter/material.dart';
import 'package:studio_25_pilates_app/presentation/views/views.dart';
import 'package:studio_25_pilates_app/presentation/widgets/shared/custom_bottom_navigation.dart';

class HomeScreen extends StatelessWidget {
  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});
  final viewRoutes = const <Widget>[
    HomeView(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
    PerfilView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: pageIndex, children: viewRoutes),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}
