import '../../domain/entities/pokemon_entity.dart';

class SearchPokemonUseCase {
  List<PokemonEntity> execute(List<PokemonEntity> pokemons, String query) {
    return pokemons
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}
