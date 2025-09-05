import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pokedex_app/core/entities/pokemon_entity.dart';
// Ejecuta la funcion y devuelve una lista de Pokemones 
Future<List<PokemonEntity>> fetchPokemons() async {
  // aquie realizo la peticion a la API de PokeAPI
  final response = await http
      .get(Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=00&limit=20'));
// Verifico si la respuesta es exitosa
  if (response.statusCode == 200) {
    //convierto el json en un map y obtengo los resultados
    List<dynamic> results = json.decode(response.body)['results'];
    List<PokemonEntity> pokemons = [];
    // Itero sobre los resultados y obtengo los detalles de cada Pokemon
    for (var result in results) {
      final detailsResponse = await http.get(Uri.parse(result['url']));
      if (detailsResponse.statusCode == 200) {
        var details = json.decode(detailsResponse.body);
        pokemons.add(PokemonEntity.fromJson(details));
      } else {
        throw Exception('Failed to load details for ${result['name']}');
      }
    }
// devuelvo mi lista de Pokemones
    return pokemons;
  } else {
    // si la respuesta falla muestro  una excepcion
    throw Exception('Falla al cargar los pokemones');
  }
}
