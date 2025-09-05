class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final String species;
  bool isFavorite;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.stats,
    required this.abilities,
    required this.species,
    this.isFavorite = false,
  });

  Pokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<String>? types,
    int? height,
    int? weight,
    List<PokemonStat>? stats,
    List<PokemonAbility>? abilities,
    String? species,
    bool? isFavorite,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      stats: stats ?? this.stats,
      abilities: abilities ?? this.abilities,
      species: species ?? this.species,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({
    required this.name,
    required this.baseStat,
  });
}

class PokemonAbility {
  final String name;
  final bool isHidden;

  PokemonAbility({
    required this.name,
    required this.isHidden,
  });
}

class PokemonListResponse {
  final List<PokemonBasic> results;
  final String? next;
  final String? previous;

  PokemonListResponse({
    required this.results,
    this.next,
    this.previous,
  });
}

class PokemonBasic {
  final String name;
  final String url;

  PokemonBasic({
    required this.name,
    required this.url,
  });

  int get id {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }
}