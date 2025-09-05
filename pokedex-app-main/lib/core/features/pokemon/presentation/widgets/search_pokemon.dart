import 'package:flutter/material.dart';

class SearchPokemon extends StatefulWidget {
  const SearchPokemon({super.key});

  @override
  State<SearchPokemon> createState() => _SearchPokemonState();
}

class _SearchPokemonState extends State<SearchPokemon> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Pokémon',
        hintStyle: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontSize: 16,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: Color.fromARGB(255, 196, 189, 189),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
