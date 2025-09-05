import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/providers/pokemon_provider.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/widgets/pokemon_type_chip.dart';
import 'package:pokedex_app/core/features/pokemon/domain/entities/pokemon.dart';

class PokemonDetailScreen extends ConsumerWidget {
  final int pokemonId;

  const PokemonDetailScreen({
    super.key,
    required this.pokemonId,
  });

  Color getTypeColor(List<String> types) {
    if (types.isEmpty) return const Color(0xFF63BC5A);
    
    final primaryType = types.first.toLowerCase();

    switch (primaryType) {
      case 'grass':
        return const Color(0xFF63BC5A);
      case 'fire':
        return const Color(0xFFFF9D55);
      case 'water':
        return const Color(0xFF5090D6);
      case 'electric':
        return const Color(0xFFF4D23C);
      case 'psychic':
        return const Color(0xFFFA7179);
      case 'ice':
        return const Color(0xFF73CEC0);
      case 'dragon':
        return const Color(0xFF0F6AC0);
      case 'dark':
        return const Color(0xFF5A5465);
      case 'fairy':
        return const Color(0xFFFB89EB);
      case 'normal':
        return const Color(0xFF9099A1);
      case 'fighting':
        return const Color(0xFFCE4069);
      case 'poison':
        return const Color(0xFFB567CE);
      case 'ground':
        return const Color(0xFFD97746);
      case 'flying':
        return const Color(0xFF89AAE3);
      case 'bug':
        return const Color(0xFF90C12C);
      case 'rock':
        return const Color(0xFFC7B78B);
      case 'ghost':
        return const Color(0xFF5269AC);
      case 'steel':
        return const Color(0xFF5A8EA1);
      default:
        return const Color(0xFF63BC5A);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonAsync = ref.watch(pokemonDetailsProvider(pokemonId));
    final isFavorite = ref.watch(favoritePokemonProvider.notifier).isFavorite(pokemonId);

    return Scaffold(
      body: pokemonAsync.when(
        data: (pokemon) => _buildPokemonDetail(context, ref, pokemon, isFavorite),
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando detalles...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text('Error al cargar el Pokémon'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _safeNavigateBack(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.home),
                    label: const Text('Inicio'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonDetail(BuildContext context, WidgetRef ref, Pokemon pokemon, bool isFavorite) {
    final primaryColor = getTypeColor(pokemon.types);
    
    return CustomScrollView(
      slivers: [
        // App Bar con imagen del Pokémon
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => _safeNavigateBack(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () => context.go('/'),
              tooltip: 'Ir al inicio',
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
              onPressed: () {
                ref.read(favoritePokemonProvider.notifier).toggleFavorite(pokemon);
              },
              tooltip: isFavorite ? 'Quitar de favoritos' : 'Agregar a favoritos',
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    primaryColor,
                    primaryColor.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Patrón de fondo
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0.7, -0.3),
                          radius: 1.5,
                          colors: [
                            Colors.white.withValues(alpha: 0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Imagen del Pokémon
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        pokemon.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: pokemon.imageUrl,
                                height: 200,
                                width: 200,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.catching_pokemon,
                                  size: 100,
                                  color: Colors.white,
                                ),
                                memCacheHeight: 400, // Optimización de memoria
                                memCacheWidth: 400,
                              )
                            : const Icon(
                                Icons.catching_pokemon,
                                size: 100,
                                color: Colors.white,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Contenido principal
        SliverToBoxAdapter(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre y número
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          pokemon.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ),
                      Text(
                        'N°${pokemon.id.toString().padLeft(3, '0')}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Especie
                  Text(
                    pokemon.species,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Tipos
                  Row(
                    children: pokemon.types
                        .map((type) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: PokemonTypeChip(type: type),
                            ))
                        .toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Información física
                  _buildInfoSection(
                    context,
                    'Información Física',
                    [
                      _buildInfoRow('Altura', '${(pokemon.height / 10).toStringAsFixed(1)} m'),
                      _buildInfoRow('Peso', '${(pokemon.weight / 10).toStringAsFixed(1)} kg'),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Habilidades
                  _buildInfoSection(
                    context,
                    'Habilidades',
                    pokemon.abilities.map((ability) => 
                      _buildInfoRow(
                        ability.name,
                        ability.isHidden ? 'Oculta' : 'Normal',
                      )
                    ).toList(),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Estadísticas
                  _buildStatsSection(context, pokemon.stats),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, List<PokemonStat> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas Base',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 12),
        ...stats.map((stat) => _buildStatBar(stat)),
      ],
    );
  }

  Widget _buildStatBar(PokemonStat stat) {
    final percentage = (stat.baseStat / 255).clamp(0.0, 1.0);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                stat.baseStat.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatColor(percentage),
            ),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Color _getStatColor(double percentage) {
    if (percentage >= 0.8) return Colors.green;
    if (percentage >= 0.6) return Colors.orange;
    if (percentage >= 0.4) return Colors.yellow;
    return Colors.red;
  }

  void _safeNavigateBack(BuildContext context) {
    if (Navigator.of(context).canPop()) {
      context.pop();
    } else {
      context.go('/');
    }
  }
}