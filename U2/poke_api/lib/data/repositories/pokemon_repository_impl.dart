import '../../domain/entities/pokemon_entity.dart';
import '../datasource/pokemon_remote_datasource.dart';

class PokemonRepositoryImpl {
  final PokemonRemoteDataSource dataSource;

  PokemonRepositoryImpl(this.dataSource);

  Future<List<PokemonEntity>> getAllPokemon({int offset = 0, int limit = 10}) async {
    final rawList = await dataSource.fetchPokemonList(offset: offset, limit: limit);
    return rawList.map((json) {
      return PokemonEntity(
        name: json['name'],
        imageUrl: json['sprites']['front_default'],
        types: (json['types'] as List)
            .map((t) => t['type']['name'] as String)
            .toList(),
        height: json['height'],
        weight: json['weight'],
        abilities: (json['abilities'] as List)
            .map((a) => a['ability']['name'] as String)
            .toList(),
      );
    }).toList();
  }
}
