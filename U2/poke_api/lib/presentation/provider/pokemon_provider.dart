import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../../data/repositories/pokemon_repository_impl.dart';
import '../../data/datasource/pokemon_remote_datasource.dart';
import '../../../aplication/usecase/search_pokemon_usecase.dart';

class PokemonProvider extends ChangeNotifier {
  final _repo = PokemonRepositoryImpl(PokemonRemoteDataSource());
  final _searchUseCase = SearchPokemonUseCase();

  List<PokemonEntity> _allPokemons = [];
  List<PokemonEntity> _pokemons = [];
  List<PokemonEntity> _filteredPokemons = [];
  bool _loading = true;

  // Paginación
  int _currentPage = 1;
  int _totalPokemons = 100;
  int _pokemonsPerPage = 10;

  List<PokemonEntity> get pokemons => _pokemons;
  List<PokemonEntity> get filteredPokemons => _filteredPokemons;
  bool get loading => _loading;
  int get currentPage => _currentPage;
  int get totalPages => (_totalPokemons / _pokemonsPerPage).ceil();

  Future<void> loadPokemons({int page = 1}) async {
    _loading = true;
    notifyListeners();
    _currentPage = page;
    // Cargar todos los pokemones solo una vez para búsqueda global
    if (_allPokemons.isEmpty) {
      List<PokemonEntity> all = [];
      for (int i = 0; i < _totalPokemons; i += _pokemonsPerPage) {
        final batch = await _repo.getAllPokemon(offset: i, limit: _pokemonsPerPage);
        all.addAll(batch);
      }
      _allPokemons = all;
    }
    final offset = (page - 1) * _pokemonsPerPage;
    _pokemons = _allPokemons.skip(offset).take(_pokemonsPerPage).toList();
    _filteredPokemons = _pokemons;
    _loading = false;
    notifyListeners();
  }

   void searchPokemon(String query) {
    List<PokemonEntity> baseList = _selectedType == 'Todos'
        ? _allPokemons
        : _allPokemons.where((p) => p.types.contains(_selectedType)).toList();
    if (query.isEmpty) {
      final offset = (_currentPage - 1) * _pokemonsPerPage;
      _filteredPokemons = baseList.skip(offset).take(_pokemonsPerPage).toList();
    } else {
      final results = _searchUseCase.execute(baseList, query);
      _filteredPokemons = results.skip((_currentPage - 1) * _pokemonsPerPage).take(_pokemonsPerPage).toList();
    }
    notifyListeners();
  }
  
  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;
    _currentPage = page;
    searchPokemon("");
    notifyListeners();
  }
    // --- Agrega estas propiedades y métodos ---
  String _selectedType = 'Todos';
  List<String> get availableTypes {
    final types = <String>{};
    for (final p in _allPokemons) {
      types.addAll(p.types);
    }
    return ['Todos', ...types.toList()..sort()];
  }
  String get selectedType => _selectedType;
  
  void filterByType(String type) {
    _selectedType = type;
    List<PokemonEntity> filtered;
    if (type == 'Todos') {
      filtered = _allPokemons;
    } else {
      filtered = _allPokemons.where((p) => p.types.contains(type)).toList();
    }
    final offset = (_currentPage - 1) * _pokemonsPerPage;
    _filteredPokemons = filtered.skip(offset).take(_pokemonsPerPage).toList();
    notifyListeners();
  }
  
  // Modifica searchPokemon para que use el filtro de tipo:

  
}
