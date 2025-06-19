import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/provider/pokemon_provider.dart';
import 'presentation/view/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PokemonProvider()..loadPokemons(),
      child: MaterialApp(
        home: HomeScreen(),
      ),
    );
  }
}