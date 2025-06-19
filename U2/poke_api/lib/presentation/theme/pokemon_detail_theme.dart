import 'package:flutter/material.dart';

class PokemonDetailTheme {
  // Colores principales
  static const Color backgroundColor = Colors.white;
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color cardBackground = Color(0xFFF7FAFC);

  // Altura del SliverAppBar expandido
  static const double expandedHeight = 300.0;

  // Colores por tipo de Pokémon (mismo que en home_theme)
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

  // Decoración del botón de atrás
  static BoxDecoration get backButtonDecoration => BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    shape: BoxShape.circle,
  );

  // Decoración del fondo del header con gradiente
  static BoxDecoration headerBackground(Color typeColor) => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        typeColor.withOpacity(0.8),
        typeColor,
      ],
    ),
  );

  // Decoración de círculos decorativos grandes
  static BoxDecoration get largeDecorativeCircle => BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    shape: BoxShape.circle,
  );

  // Decoración de círculos decorativos pequeños
  static BoxDecoration get smallDecorativeCircle => BoxDecoration(
    color: Colors.white.withOpacity(0.1),
    shape: BoxShape.circle,
  );

  // Decoración del contenedor de imagen principal
  static BoxDecoration get mainImageContainer => BoxDecoration(
    color: Colors.white.withOpacity(0.2),
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 20,
        offset: Offset(0, 10),
      ),
    ],
  );

  // Estilo del título principal (nombre del Pokémon)
  static TextStyle get mainTitleStyle => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(2, 2),
        blurRadius: 4,
        color: Colors.black.withOpacity(0.3),
      ),
    ],
  );

  // Decoración del contenedor principal de contenido
  static BoxDecoration get contentContainerDecoration => BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    ),
  );

  // Padding del contenido principal
  static EdgeInsets get contentPadding => EdgeInsets.all(24);

  // Decoración de chips de tipo
  static BoxDecoration typeChipDecoration(Color typeColor) => BoxDecoration(
    color: typeColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: typeColor.withOpacity(0.3),
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  );

  // Estilo del texto de chips de tipo
  static TextStyle get typeChipTextStyle => TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  // Padding de chips de tipo
  static EdgeInsets get typeChipPadding => 
    EdgeInsets.symmetric(horizontal: 20, vertical: 8);

  // Estilo de títulos de sección
  static TextStyle get sectionTitleStyle => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  // Decoración de cards de estadísticas
  static BoxDecoration statCardDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.1),
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: color.withOpacity(0.3),
      width: 1,
    ),
  );

  // Padding de cards de estadísticas
  static EdgeInsets get statCardPadding => EdgeInsets.all(20);

  // Decoración del contenedor de iconos de estadísticas
  static BoxDecoration statIconDecoration(Color color) => BoxDecoration(
    color: color.withOpacity(0.2),
    shape: BoxShape.circle,
  );

  // Estilo del label de estadísticas
  static TextStyle get statLabelStyle => TextStyle(
    fontSize: 14,
    color: textSecondary,
    fontWeight: FontWeight.w500,
  );

  // Estilo del valor de estadísticas
  static TextStyle statValueStyle(Color color) => TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: color,
  );

  // Decoración de cards de habilidades
  static BoxDecoration abilityCardDecoration(Color typeColor) => BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(15),
    border: Border.all(
      color: typeColor.withOpacity(0.3),
      width: 1,
    ),
  );

  // Padding de cards de habilidades
  static EdgeInsets get abilityCardPadding => EdgeInsets.all(16);

  // Decoración del contenedor de iconos de habilidades
  static BoxDecoration abilityIconDecoration(Color typeColor) => BoxDecoration(
    color: typeColor.withOpacity(0.2),
    shape: BoxShape.circle,
  );

  // Estilo del texto de habilidades
  static TextStyle get abilityTextStyle => TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: textPrimary,
  );

  // Espaciado estándar
  static const double standardSpacing = 16.0;
  static const double largeSpacing = 32.0;
  static const double smallSpacing = 8.0;
  static const double extraSmallSpacing = 4.0;

  // Tamaños de iconos
  static const double smallIconSize = 20.0;
  static const double mediumIconSize = 24.0;
  static const double largeIconSize = 80.0;

  // Tamaños de contenedores
  static const double smallContainerSize = 40.0;
  static const double mediumContainerSize = 50.0;
  static const double largeContainerSize = 150.0;
}