import 'package:dio/dio.dart';
import 'package:pokedex_app/core/features/pokemon/domain/entities/pokemon.dart';

class PokemonService {
  final Dio _dio;
  static const String baseUrl = 'https://pokeapi.co/api/v2';
  
  // Cache para evitar peticiones repetidas
  final Map<int, Pokemon> _pokemonCache = {};
  final Map<String, PokemonListResponse> _listCache = {};

  PokemonService() : _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<PokemonListResponse> getPokemonList({int limit = 20, int offset = 0}) async {
    final cacheKey = 'list_${limit}_$offset';
    
    // Verificar cache primero
    if (_listCache.containsKey(cacheKey)) {
      return _listCache[cacheKey]!;
    }

    try {
      final response = await _dio.get('/pokemon', queryParameters: {
        'limit': limit,
        'offset': offset,
      });

      final results = (response.data['results'] as List)
          .map((json) => PokemonBasic(
                name: json['name'],
                url: json['url'],
              ))
          .toList();

      final pokemonListResponse = PokemonListResponse(
        results: results,
        next: response.data['next'],
        previous: response.data['previous'],
      );

      // Guardar en cache
      _listCache[cacheKey] = pokemonListResponse;
      
      return pokemonListResponse;
    } catch (e) {
      throw Exception('Error fetching Pokemon list: $e');
    }
  }

  Future<Pokemon> getPokemonDetails(int id) async {
    // Verificar cache primero
    if (_pokemonCache.containsKey(id)) {
      return _pokemonCache[id]!;
    }

    try {
      // Hacer ambas peticiones en paralelo para optimizar
      final futures = await Future.wait([
        _dio.get('/pokemon/$id'),
        _dio.get('/pokemon-species/$id'),
      ]);

      final pokemonResponse = futures[0];
      final speciesResponse = futures[1];
      
      final data = pokemonResponse.data;
      final speciesData = speciesResponse.data;

      final pokemon = Pokemon(
        id: data['id'],
        name: _capitalize(data['name']),
        imageUrl: data['sprites']['other']['official-artwork']['front_default'] ?? 
                 data['sprites']['front_default'] ?? '',
        types: (data['types'] as List)
            .map((type) => _capitalize(type['type']['name']))
            .toList(),
        height: data['height'],
        weight: data['weight'],
        stats: (data['stats'] as List)
            .map((stat) => PokemonStat(
                  name: _formatStatName(stat['stat']['name']),
                  baseStat: stat['base_stat'],
                ))
            .toList(),
        abilities: (data['abilities'] as List)
            .map((ability) => PokemonAbility(
                  name: _capitalize(ability['ability']['name']),
                  isHidden: ability['is_hidden'] ?? false,
                ))
            .toList(),
        species: _getSpeciesName(speciesData),
      );

      // Guardar en cache
      _pokemonCache[id] = pokemon;
      
      return pokemon;
    } catch (e) {
      throw Exception('Error fetching Pokemon details for ID $id: $e');
    }
  }

  String _getSpeciesName(Map<String, dynamic> speciesData) {
    try {
      final genera = speciesData['genera'] as List;
      final englishGenus = genera.firstWhere(
        (genus) => genus['language']['name'] == 'en',
        orElse: () => {'genus': 'Unknown Pokémon'},
      );
      return _capitalize(englishGenus['genus']);
    } catch (e) {
      return 'Unknown Pokémon';
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String _formatStatName(String statName) {
    switch (statName) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Attack';
      case 'special-defense':
        return 'Sp. Defense';
      case 'speed':
        return 'Speed';
      default:
        return _capitalize(statName);
    }
  }

  // Método para limpiar cache si es necesario
  void clearCache() {
    _pokemonCache.clear();
    _listCache.clear();
  }

  // Método para precarga de Pokemon populares
  Future<void> preloadPopularPokemon() async {
    final popularIds = [1, 4, 7, 25, 39, 52, 104, 113, 131, 144]; // IDs populares
    
    final futures = popularIds.map((id) => getPokemonDetails(id)).toList();
    await Future.wait(futures);
  }
}