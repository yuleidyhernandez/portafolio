import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/screens/pokemon_list_screen.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/screens/pokemon_detail_screen.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/screens/favorites_screen.dart';
import 'package:pokedex_app/core/widgets/main_layout.dart';
import 'package:pokedex_app/core/features/shared/screens/error_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const PokemonListScreen(),
          ),
        ],
      ),
      // Rutas fuera del MainLayout
      GoRoute(
        path: '/pokemon/:id',
        name: 'pokemon_detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return PokemonDetailScreen(pokemonId: id);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
});
