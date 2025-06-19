import 'dart:convert';
import 'package:http/http.dart' as http;

class PokemonRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchPokemonList({int offset = 0, int limit = 10}) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final List<dynamic> results = json.decode(response.body)['results'];
      return Future.wait(results.map((item) async {
        final res = await http.get(Uri.parse(item['url']));
        return json.decode(res.body);
      }));
    } else {
      throw Exception('Error al cargar Pokémon');
    }
  }
}
