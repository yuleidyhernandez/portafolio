import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex_app/core/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/widgets/pokemon_type_chip.dart';

class PokemonCardOptimized extends StatelessWidget {
  final Pokemon pokemon;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const PokemonCardOptimized({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  Color getCardBackgroundColor() {
    if (pokemon.types.isEmpty) return const Color(0xFFEDF6EC);
    
    final primaryType = pokemon.types.first.toLowerCase();

    switch (primaryType) {
      case 'grass':
        return const Color(0xFFEDF6EC);
      case 'fire':
        return const Color(0xFFFCF3EB);
      case 'water':
        return const Color(0xFFEBF1F8);
      case 'electric':
        return const Color(0xFFFBF8E9);
      case 'psychic':
        return const Color(0xFFF8ECF4);
      case 'ice':
        return const Color(0xFFECF8F8);
      case 'dragon':
        return const Color(0xFFECECF8);
      case 'dark':
        return const Color(0xFFF0F0F0);
      case 'fairy':
        return const Color(0xFFF8ECF8);
      case 'normal':
        return const Color(0xFFF5F5F5);
      case 'fighting':
        return const Color(0xFFF8ECEC);
      case 'poison':
        return const Color(0xFFF4ECF8);
      case 'ground':
        return const Color(0xFFF8F4EC);
      case 'flying':
        return const Color(0xFFECF4F8);
      case 'bug':
        return const Color(0xFFF0F8EC);
      case 'rock':
        return const Color(0xFFF8F0EC);
      case 'ghost':
        return const Color(0xFFECECF8);
      case 'steel':
        return const Color(0xFFECF8F4);
      default:
        return const Color(0xFFEDF6EC);
    }
  }

  Color getTypeColor() {
    if (pokemon.types.isEmpty) return const Color(0xFF63BC5A);
    
    final primaryType = pokemon.types.first.toLowerCase();

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
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final bgColor = getTypeColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: getCardBackgroundColor(),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'N°${pokemon.id.toString().padLeft(3, '0')}',
                        style: textStyle.bodyMedium?.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      Flexible(
                        child: Text(
                          pokemon.name,
                          style: textStyle.titleMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: pokemon.types
                              .map((type) => PokemonTypeChip(type: type))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: bgColor,
                  ),
                  child: Stack(
                    children: [
                      // Patrón de fondo sutil
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: RadialGradient(
                              center: const Alignment(0.7, -0.7),
                              radius: 1.2,
                              colors: [
                                Colors.white.withValues(alpha: 0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // SVG del tipo de Pokémon (centrado, como fondo)
                      Center(
                        child: _buildTypeIcon(),
                      ),
                      
                      // Imagen del Pokémon (centrada)
                      Center(
                        child: pokemon.imageUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: pokemon.imageUrl,
                                height: 65,
                                width: 65,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => Container(
                                  height: 65,
                                  width: 65,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.3),
                                    borderRadius: BorderRadius.circular(32.5),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.catching_pokemon,
                                  size: 35,
                                  color: Colors.white,
                                ),
                                memCacheHeight: 130, // Optimización de memoria
                                memCacheWidth: 130,
                              )
                            : const Icon(
                                Icons.catching_pokemon,
                                size: 35,
                                color: Colors.white,
                              ),
                      ),
                      
                      // Corazón de favorito (esquina superior derecha)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    if (pokemon.types.isEmpty) return const SizedBox.shrink();
    
    final primaryType = pokemon.types.first.toLowerCase();
    String iconPath = 'assets/pokemons_types/';
    
    // Mapear todos los tipos de Pokémon a sus SVG correspondientes
    switch (primaryType) {
      case 'normal':
        iconPath += 'normal.svg';
        break;
      case 'fire':
        iconPath += 'fire.svg';
        break;
      case 'water':
        iconPath += 'water.svg';
        break;
      case 'electric':
        iconPath += 'electric.svg';
        break;
      case 'grass':
        iconPath += 'grass.svg';
        break;
      case 'ice':
        iconPath += 'ice.svg';
        break;
      case 'fighting':
        iconPath += 'fighting.svg';
        break;
      case 'poison':
        iconPath += 'poison.svg';
        break;
      case 'ground':
        iconPath += 'ground.svg';
        break;
      case 'flying':
        iconPath += 'flying.svg';
        break;
      case 'psychic':
        iconPath += 'psychic.svg';
        break;
      case 'bug':
        iconPath += 'bug.svg';
        break;
      case 'rock':
        iconPath += 'rock.svg';
        break;
      case 'ghost':
        iconPath += 'ghost.svg';
        break;
      case 'dragon':
        iconPath += 'dragon.svg';
        break;
      case 'dark':
        iconPath += 'dark.svg';
        break;
      case 'steel':
        iconPath += 'steel.svg';
        break;
      case 'fairy':
        iconPath += 'fairy.svg';
        break;
      default:
        // Si no hay SVG específico, usar normal como fallback
        iconPath += 'normal.svg';
        break;
    }

    return SvgPicture.asset(
      iconPath,
      height: 80,
      width: 80,
      colorFilter: ColorFilter.mode(
        Colors.white.withValues(alpha: 0.3),
        BlendMode.srcIn,
      ),
    );
  }
}