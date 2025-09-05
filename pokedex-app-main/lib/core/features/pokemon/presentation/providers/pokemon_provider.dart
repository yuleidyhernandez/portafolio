import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokedex_app/core/features/pokemon/domain/entities/pokemon.dart';
import 'package:pokedex_app/core/features/pokemon/data/services/pokemon_service.dart';

// Provider del servicio
final pokemonServiceProvider = Provider<PokemonService>((ref) {
  return PokemonService();
});

// Provider para la lista de Pokemon
final pokemonListProvider = StateNotifierProvider<PokemonListNotifier, AsyncValue<List<Pokemon>>>((ref) {
  final service = ref.watch(pokemonServiceProvider);
  return PokemonListNotifier(service);
});

// Provider para Pokemon favoritos
final favoritePokemonProvider = StateNotifierProvider<FavoritePokemonNotifier, List<Pokemon>>((ref) {
  return FavoritePokemonNotifier();
});

// Provider para detalles de un Pokemon específico
final pokemonDetailsProvider = FutureProvider.family<Pokemon, int>((ref, id) async {
  final service = ref.watch(pokemonServiceProvider);
  return service.getPokemonDetails(id);
});

class PokemonListNotifier extends StateNotifier<AsyncValue<List<Pokemon>>> {
  final PokemonService _service;
  List<Pokemon> _allPokemon = [];
  int _currentOffset = 0;
  static const int _limit = 20;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  PokemonListNotifier(this._service) : super(const AsyncValue.loading()) {
    loadInitialPokemon();
  }

  Future<void> loadInitialPokemon() async {
    try {
      state = const AsyncValue.loading();
      final response = await _service.getPokemonList(limit: _limit, offset: 0);
      
      // Cargar Pokemon en lotes para mejorar la experiencia
      final pokemonList = <Pokemon>[];
      final futures = <Future<Pokemon>>[];
      
      // Crear todas las peticiones de una vez
      for (final basicPokemon in response.results) {
        futures.add(_service.getPokemonDetails(basicPokemon.id));
      }
      
      // Esperar a que todas se completen
      final results = await Future.wait(futures);
      pokemonList.addAll(results);
      
      _allPokemon = pokemonList;
      _currentOffset = _limit;
      _hasMoreData = response.next != null;
      state = AsyncValue.data(pokemonList);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadMorePokemon() async {
    if (_isLoadingMore || !_hasMoreData || state.isLoading) return;
    
    _isLoadingMore = true;
    
    try {
      final response = await _service.getPokemonList(
        limit: _limit, 
        offset: _currentOffset
      );
      
      if (response.results.isEmpty) {
        _hasMoreData = false;
        _isLoadingMore = false;
        return;
      }
      
      // Cargar nuevos Pokemon en paralelo
      final futures = <Future<Pokemon>>[];
      for (final basicPokemon in response.results) {
        futures.add(_service.getPokemonDetails(basicPokemon.id));
      }
      
      final newPokemonList = await Future.wait(futures);
      
      _allPokemon.addAll(newPokemonList);
      _currentOffset += _limit;
      _hasMoreData = response.next != null;
      
      // Actualizar el estado con la nueva lista
      state = AsyncValue.data([..._allPokemon]);
    } catch (error) {
      // Mantener el estado actual en caso de error
      debugPrint('Error loading more Pokemon: $error');
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refreshPokemon() async {
    _currentOffset = 0;
    _allPokemon.clear();
    _hasMoreData = true;
    _isLoadingMore = false;
    await loadInitialPokemon();
  }

  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
}

class FavoritePokemonNotifier extends StateNotifier<List<Pokemon>> {
  FavoritePokemonNotifier() : super([]);

  void toggleFavorite(Pokemon pokemon) {
    final currentFavorites = [...state];
    final existingIndex = currentFavorites.indexWhere((p) => p.id == pokemon.id);
    
    if (existingIndex >= 0) {
      // Remover de favoritos
      currentFavorites.removeAt(existingIndex);
    } else {
      // Agregar a favoritos
      currentFavorites.add(pokemon.copyWith(isFavorite: true));
    }
    
    state = currentFavorites;
  }

  bool isFavorite(int pokemonId) {
    return state.any((pokemon) => pokemon.id == pokemonId);
  }

  void removeFavorite(int pokemonId) {
    state = state.where((pokemon) => pokemon.id != pokemonId).toList();
  }

  void clearFavorites() {
    state = [];
  }
}