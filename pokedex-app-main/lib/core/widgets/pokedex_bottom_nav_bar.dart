import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class PokedexBottomNavBar extends StatelessWidget {
  const PokedexBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currectLocation = GoRouterState.of(context).uri.toString();

    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
            //! # -> 0xFF
            color: Colors.white)
      ]),
      child: BottomNavigationBar(
          currentIndex: _calulateSelectdIndex(currectLocation),
          onTap: (index) => _onTapItem(context, index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xff173EA5),
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: _buildIconBar('home_inactive'),
              activeIcon: _buildIconBar('home_active'),
              label: 'Pokedéx',
            ),
            BottomNavigationBarItem(
              icon: _buildIconBar('search_inactive'),
              activeIcon: _buildIconBar('search_active'),
              label: 'Regiones',
            ),
            BottomNavigationBarItem(
              icon: _buildIconBar('favorite_inactive'),
              activeIcon: _buildIconBar('favorite_active'),
              label: 'Favoritos',
            ),
            BottomNavigationBarItem(
              icon: _buildIconBar('profile_inactive'),
              activeIcon: _buildIconBar('profile_active'),
              label: 'Perfil',
            )
          ]),
    );
  }

  Widget _buildIconBar(String icon) {
    final String iconPath = 'assets/nav_bar/';
    return SvgPicture.asset('${iconPath + icon }.svg',);
  }

  int _calulateSelectdIndex(String location) {
    if (location == '/') return 0;
    if (location == '/search') return 1;
    if (location == '/favorites') return 2;
    if (location == '/profile') return 3;
    return 0;
  }

  void _onTapItem(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;

      case 1:
        _showDiagol(context);
        break;
      case 2:
        context.go('/favorites');
        break;
      case 3:
        _showDiagol(context);
        break;
    }
  }

  void _showDiagol(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Pantalla en construcción...'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cerrar')),
              ],
            ));
  }
}