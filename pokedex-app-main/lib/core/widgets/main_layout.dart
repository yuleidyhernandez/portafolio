import 'package:flutter/material.dart';
import 'package:pokedex_app/core/widgets/pokedex_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: PokedexBottomNavBar(),
    );
  }
}