class PokemonEntity {
  final String id;
  final String name;
  final List<String> types;
  final String backgroundColor;
  final String image;

  PokemonEntity({
    required this.id,
    required this.name,
    required this.types,
    required this.backgroundColor,
    required this.image,
  });
  // Factory constructor para crear una instancia de PokemonEntity desde el JSON
  factory PokemonEntity.fromJson(Map<String, dynamic> json) {
    List<String> types = [];
    if (json['types'] is List) {
      types = json['types'].map<String>((dynamic type) {
        // verifico si cada elemento es un map
        if (type is Map &&
            type.containsKey('type') &&
            type['type'] is Map &&
            type['type'].containsKey('name')) {
          return type['type']['name'] as String;
        } else {
          throw Exception('Invalid type structure');
        }
      }).toList(); //despues de cada mapeo lo conviero en una lista
    }
    // estoy retornando y creando una instancia de PokemonEntity
    return PokemonEntity(
      id: json['id'].toString(),
      name: json['name'],
      types: types,
      backgroundColor: _getBackgroundColor(types.first),
      image: json['sprites']['front_default'] ?? '',
    );
  }
// les doy un color de fondo a cada tipo de Pokemon
  static String _getBackgroundColor(String type) {
    switch (type) {
      case 'fire':
        return '#F08030';
      case 'water':
        return '#6890F0';
      case 'grass':
        return '#78C850';
      case 'electric':
        return '#F8D030';
      case 'ice':
        return '#98D8D8';
      case 'fighting':
        return '#C03028';
      case 'poison':
        return '#A040A0';
      case 'ground':
        return '#E0C068';
      case 'flying':
        return '#A890F0';
      case 'psychic':
        return '#F85888';
      case 'bug':
        return '#A8B820';
      case 'rock':
        return '#B8A038';
      case 'ghost':
        return '#705898';
      case 'dragon':
        return '#7038F8';
      case 'dark':
        return '#705848';
      case 'steel':
        return '#B8B8D0';
      case 'fairy':
        return '#EE99AC';
      default:
        return '#A8A878';
    }
  }
}
