import 'package:flutter/material.dart';

class HomeTheme {
  // Colores principales
  static const Color primaryColor = Color(0xFFE53E3E);
  static const Color primaryLight = Color(0xFFFC8181);
  static const Color backgroundColor = Color(0xFFF7FAFC);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color searchBackground = Colors.white;

  // AppBar Style
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  // Decoración del header
  static BoxDecoration get headerDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [primaryColor, primaryLight],
    ),
  );

  // Estilo del campo de búsqueda
  static BoxDecoration get searchFieldDecoration => BoxDecoration(
    color: searchBackground,
    borderRadius: BorderRadius.circular(25),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: Offset(0, 5),
      ),
    ],
  );

  // Input decoration para el campo de búsqueda
  static InputDecoration get searchInputDecoration => InputDecoration(
    hintText: 'Buscar Pokémon...',
    hintStyle: TextStyle(color: Colors.grey[500]),
    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: searchBackground,
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
  );

  // Estilo para el indicador de carga
  static Widget get loadingIndicator => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircularProgressIndicator(
        color: primaryColor,
        strokeWidth: 3,
      ),
      SizedBox(height: 20),
      Text(
        'Cargando Pokémon...',
        style: TextStyle(
          color: textSecondary,
          fontSize: 16,
        ),
      ),
    ],
  );

  // Widget para estado vacío
  static Widget get emptyState => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.search_off,
        size: 80,
        color: Colors.grey[400],
      ),
      SizedBox(height: 20),
      Text(
        'No se encontraron Pokémon',
        style: TextStyle(
          fontSize: 18,
          color: textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  // Grid delegate para la lista de Pokémon
  static SliverGridDelegate get gridDelegate => 
    SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 0.8,
    );

  // Padding para el grid
  static EdgeInsets get gridPadding => EdgeInsets.all(16);

  // Colores por tipo de Pokémon
  static Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire': return Colors.red[400]!;
      case 'water': return Colors.blue[400]!;
      case 'grass': return Colors.green[400]!;
      case 'electric': return Colors.yellow[600]!;
      case 'psychic': return Colors.purple[400]!;
      case 'ice': return Colors.cyan[300]!;
      case 'dragon': return Colors.indigo[400]!;
      case 'dark': return Colors.grey[800]!;
      case 'fairy': return Colors.pink[300]!;
      case 'fighting': return Colors.red[700]!;
      case 'poison': return Colors.purple[600]!;
      case 'ground': return Colors.brown[400]!;
      case 'flying': return Colors.indigo[300]!;
      case 'bug': return Colors.green[600]!;
      case 'rock': return Colors.grey[600]!;
      case 'ghost': return Colors.purple[700]!;
      case 'steel': return Colors.blueGrey[400]!;
      case 'normal': return Colors.grey[400]!;
      default: return Colors.grey[400]!;
    }
  }

  // Decoración para las cards de Pokémon
  static BoxDecoration pokemonCardDecoration(Color typeColor) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        typeColor.withOpacity(0.7),
        typeColor.withOpacity(0.9),
      ],
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: typeColor.withOpacity(0.3),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  // Decoración para el círculo de fondo decorativo
  static BoxDecoration get decorativeCircleDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    shape: BoxShape.circle,
  );

  // Decoración para el contenedor de imagen
  static BoxDecoration get imageContainerDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    shape: BoxShape.circle,
  );

  // Estilo del nombre del Pokémon
  static TextStyle get pokemonNameStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(1, 1),
        blurRadius: 2,
        color: Colors.black.withOpacity(0.3),
      ),
    ],
  );

  // Decoración para los chips de tipo
  static BoxDecoration get typeChipDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.3),
    borderRadius: BorderRadius.circular(10),
  );

  // Estilo del texto de tipo
  static TextStyle get typeTextStyle => TextStyle(
    fontSize: 10,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  // Padding para las cards
  static EdgeInsets get cardPadding => EdgeInsets.all(16);
}