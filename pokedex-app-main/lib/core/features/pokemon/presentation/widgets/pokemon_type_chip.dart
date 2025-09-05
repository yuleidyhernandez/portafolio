import 'package:flutter/material.dart';

class PokemonTypeChip extends StatelessWidget {
  final String type;
  const PokemonTypeChip({super.key, required this.type});

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return const Color(0xFF63BC5A);
      case 'fire':
        return const Color(0xFFFF9D55);
      case 'water':
        return const Color(0xFF5090D6);
      case 'electric':
        return const Color(0xFFF4D23C);
      case 'poison':
        return const Color(0xFFB567CE);
      case 'flying':
        return const Color(0xFF89AAE3);
      default:
        return const Color(0xFFEDF6EC);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle? chipTextStyle = Theme.of(context).textTheme.bodyMedium;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: getTypeColor(type),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        type, 
        style: chipTextStyle?.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
