import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pokedex_app/core/features/pokemon/presentation/widgets/pokemon_type_chip.dart';

class PokemonCard extends StatelessWidget {
  final String id;
  final String name;
  final String image;
  final List<String> types;
  final String backgroundColor;
  final String typeIcon;

  const PokemonCard({
    super.key,
    required this.id,
    required this.name,
    required this.image,
    required this.backgroundColor,
    required this.typeIcon,
    required this.types,
  });

  Color getCardBackgroundColor() {
    final primaryType = types.first.toLowerCase();

    switch (primaryType) {
      case 'grass':
        return const Color(0xFFEDF6EC);
      case 'fire':
        return const Color(0xFFFCF3EB);
      case 'water':
        return const Color(0xFFEBF1F8);
      case 'electric':
        return const Color(0xFFFBF8E9);
      default:
        return const Color(0xFFEDF6EC);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final bgColor = Color(int.parse(backgroundColor));

    return Container(
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
                      'N°$id',
                      style: textStyle.bodyMedium?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        name,
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
                        children: types
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Calcula tamaños basados en el contenedor
                    final containerSize = constraints.maxHeight;
                    final svgSize = containerSize * 1; // 60% del contenedor
                    final pokemonSize = containerSize * 1; // 75% del contenedor
                    
                    return Stack(
                      children: [
                        Center(
                          child: SvgPicture.asset(
                            typeIcon,
                            height: svgSize,
                            width: svgSize,
                            colorFilter: ColorFilter.mode(
                              Colors.white.withValues(alpha: 0.3),
                              BlendMode.srcATop,
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            image,
                            height: pokemonSize,
                            width: pokemonSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}