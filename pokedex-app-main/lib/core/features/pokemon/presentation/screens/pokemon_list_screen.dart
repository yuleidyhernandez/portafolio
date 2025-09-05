import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/providers/pokemon_provider.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/widgets/pokemon_card_optimized.dart';

class PokemonListScreen extends ConsumerStatefulWidget {
  const PokemonListScreen({super.key});

  @override
  ConsumerState<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends ConsumerState<PokemonListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      // Cargar más Pokemon cuando esté cerca del final
      ref.read(pokemonListProvider.notifier).loadMorePokemon();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonListAsync = ref.watch(pokemonListProvider);
    final favorites = ref.watch(favoritePokemonProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(pokemonListProvider.notifier).refreshPokemon();
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 50),
              // Header con título y botón de favoritos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pokédex',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      // Contador de favoritos
                      if (favorites.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '❤️ ${favorites.length}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      const SizedBox(width: 8),
                      // Botón para ir a favoritos
                      IconButton(
                        onPressed: () => context.push('/favorites'),
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        tooltip: 'Ver Favoritos',
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Lista de Pokemon
              Expanded(
                child: pokemonListAsync.when(
                  data: (pokemonList) {
                    if (pokemonList.isEmpty) {
                      return const Center(
                        child: Text('No hay Pokémon disponibles'),
                      );
                    }
                    
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: pokemonList.length + (ref.read(pokemonListProvider.notifier).hasMoreData ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == pokemonList.length) {
                          // Loading indicator al final solo si hay más datos
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: ref.read(pokemonListProvider.notifier).isLoadingMore
                                  ? const CircularProgressIndicator()
                                  : const SizedBox.shrink(),
                            ),
                          );
                        }
                        
                        final pokemon = pokemonList[index];
                        final isFavorite = ref.watch(favoritePokemonProvider.notifier).isFavorite(pokemon.id);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: PokemonCardOptimized(
                            pokemon: pokemon,
                            isFavorite: isFavorite,
                            onTap: () => context.push('/pokemon/${pokemon.id}'),
                            onFavoriteToggle: () {
                              ref.read(favoritePokemonProvider.notifier).toggleFavorite(pokemon);
                            },
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Cargando Pokémon...'),
                      ],
                    ),
                  ),
                  error: (error, stack) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error al cargar Pokémon',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Verifica tu conexión a internet',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(pokemonListProvider.notifier).refreshPokemon();
                          },
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}