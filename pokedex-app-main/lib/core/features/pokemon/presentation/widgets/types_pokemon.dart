import 'package:flutter/material.dart';

class TypesPokemon extends StatefulWidget {
  const TypesPokemon({super.key});

  @override
  State<TypesPokemon> createState() => _TypesPokemonState();
}

class _TypesPokemonState extends State<TypesPokemon> {
  final List<String> types = [
    'Todos los tipos',
    'Agua',
    'Dragon',
    'Eléctrico',
    'Fada',
    'Fantasma',
    'Fuego',
    'Gelo',
    'Grama',
    'Inseto',
    'Lutador',
  ];

  // Mapeo de colores para cada tipo
  final Map<String, Color> typeColors = {
    'Todos los tipos': Colors.grey,
    'Agua': Colors.blue,
    'Dragon': Colors.orange,
    'Eléctrico': Colors.yellow,
    'Fada': Colors.pink,
    'Fantasma': Colors.purple,
    'Fuego': Colors.red,
    'Gelo': Colors.lightBlue,
    'Grama': Colors.green,
    'Inseto': Colors.brown,
    'Lutador': Colors.orange,
  };

  String? pokemonType;

  void _showTypeModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: 300, // Ajusta según la cantidad de tipos
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: types.map((type) {
              return TextButton(
                style: TextButton.styleFrom(
                  backgroundColor:
                      pokemonType == type ? Colors.white : typeColors[type]!,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: () {
                  setState(() => pokemonType = type);
                  Navigator.pop(context);
                },
                child: Text(
                  type,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 170,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: pokemonType != null
              ? typeColors[pokemonType!]!
              : Color(0xff333333),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        onPressed: _showTypeModal,
        child: pokemonType != null
            ? Text(
                pokemonType!,
                style: const TextStyle(color: Colors.white),
              )
            : const Text('Todos los tipos'),
      ),
    );
  }
}
