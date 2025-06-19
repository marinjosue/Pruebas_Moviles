import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_entity.dart';
import '../theme/pokemon_detail_theme.dart';

class PokemonDetailScreen extends StatelessWidget {
  final PokemonEntity pokemon;

  const PokemonDetailScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal';
    final typeColor = PokemonDetailTheme.getTypeColor(primaryType);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(typeColor),
          _buildContent(typeColor),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(Color typeColor) {
    return SliverAppBar(
      expandedHeight: PokemonDetailTheme.expandedHeight,
      pinned: true,
      backgroundColor: typeColor,
      leading: Container(
        margin: EdgeInsets.all(8),
        decoration: PokemonDetailTheme.backButtonDecoration,
        child: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildHeaderBackground(typeColor),
      ),
    );
  }

  Widget _buildHeaderBackground(Color typeColor) {
    return Container(
      decoration: PokemonDetailTheme.headerBackground(typeColor),
      child: Stack(
        children: [
          _buildDecorativeElements(),
          _buildHeaderContent(),
        ],
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Stack(
      children: [
        Positioned(
          right: -50,
          top: 50,
          child: Container(
            width: 150,
            height: 150,
            decoration: PokemonDetailTheme.largeDecorativeCircle,
          ),
        ),
        Positioned(
          left: -30,
          bottom: 50,
          child: Container(
            width: 100,
            height: 100,
            decoration: PokemonDetailTheme.smallDecorativeCircle,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMainPokemonImage(),
          SizedBox(height: 20),
          _buildPokemonTitle(),
        ],
      ),
    );
  }

  Widget _buildMainPokemonImage() {
    return Container(
      width: PokemonDetailTheme.largeContainerSize,
      height: PokemonDetailTheme.largeContainerSize,
      decoration: PokemonDetailTheme.mainImageContainer,
      child: ClipOval(
        child: Image.network(
          pokemon.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.catching_pokemon,
              size: PokemonDetailTheme.largeIconSize,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPokemonTitle() {
    return Text(
      pokemon.name.toUpperCase(),
      style: PokemonDetailTheme.mainTitleStyle,
    );
  }

  Widget _buildContent(Color typeColor) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: PokemonDetailTheme.contentContainerDecoration,
        child: Padding(
          padding: PokemonDetailTheme.contentPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTypeChips(typeColor),
              SizedBox(height: PokemonDetailTheme.largeSpacing),
              _buildPhysicalStats(typeColor),
              SizedBox(height: PokemonDetailTheme.largeSpacing),
              _buildAbilities(typeColor),
              SizedBox(height: PokemonDetailTheme.largeSpacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChips(Color primaryTypeColor) {
    return Center(
      child: Wrap(
        spacing: 12,
        children: pokemon.types.map((type) {
          final typeColor = PokemonDetailTheme.getTypeColor(type);
          return Container(
            padding: PokemonDetailTheme.typeChipPadding,
            decoration: PokemonDetailTheme.typeChipDecoration(typeColor),
            child: Text(
              type.toUpperCase(),
              style: PokemonDetailTheme.typeChipTextStyle,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPhysicalStats(Color typeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Estadísticas Físicas',
          style: PokemonDetailTheme.sectionTitleStyle,
        ),
        SizedBox(height: PokemonDetailTheme.standardSpacing),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Altura',
                '${pokemon.height} m',
                Icons.height,
                Colors.blue[400]!,
              ),
            ),
            SizedBox(width: PokemonDetailTheme.standardSpacing),
            Expanded(
              child: _buildStatCard(
                'Peso',
                '${pokemon.weight} kg',
                Icons.fitness_center,
                Colors.orange[400]!,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: PokemonDetailTheme.statCardPadding,
      decoration: PokemonDetailTheme.statCardDecoration(color),
      child: Column(
        children: [
          Container(
            width: PokemonDetailTheme.mediumContainerSize,
            height: PokemonDetailTheme.mediumContainerSize,
            decoration: PokemonDetailTheme.statIconDecoration(color),
            child: Icon(
              icon,
              color: color,
              size: PokemonDetailTheme.mediumIconSize,
            ),
          ),
          SizedBox(height: 12),
          Text(label, style: PokemonDetailTheme.statLabelStyle),
          SizedBox(height: PokemonDetailTheme.extraSmallSpacing),
          Text(value, style: PokemonDetailTheme.statValueStyle(color)),
        ],
      ),
    );
  }

  Widget _buildAbilities(Color typeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Habilidades',
          style: PokemonDetailTheme.sectionTitleStyle,
        ),
        SizedBox(height: PokemonDetailTheme.standardSpacing),
        ...pokemon.abilities.map((ability) => _buildAbilityCard(ability, typeColor)),
      ],
    );
  }

  Widget _buildAbilityCard(String ability, Color typeColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: PokemonDetailTheme.abilityCardPadding,
      decoration: PokemonDetailTheme.abilityCardDecoration(typeColor),
      child: Row(
        children: [
          Container(
            width: PokemonDetailTheme.smallContainerSize,
            height: PokemonDetailTheme.smallContainerSize,
            decoration: PokemonDetailTheme.abilityIconDecoration(typeColor),
            child: Icon(
              Icons.flash_on,
              color: typeColor,
              size: PokemonDetailTheme.smallIconSize,
            ),
          ),
          SizedBox(width: PokemonDetailTheme.standardSpacing),
          Expanded(
            child: Text(
              ability,
              style: PokemonDetailTheme.abilityTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}