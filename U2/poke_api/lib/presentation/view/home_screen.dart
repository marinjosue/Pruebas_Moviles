import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/pokemon_provider.dart';
import '../theme/home_theme.dart';
import 'pokemon_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PokemonProvider>(context);
    final media = MediaQuery.of(context);
    final isSmall = media.size.width < 400;

    return Scaffold(
      backgroundColor: HomeTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: HomeTheme.primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: HomeTheme.appBarTheme.titleTextStyle,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchHeader(provider),
            Expanded(
              child: _buildPokemonGrid(provider),
            ),
            _buildPagination(provider, context, isSmall),
          ],
        ),
      ),
    );
  }

 Widget _buildSearchHeader(PokemonProvider provider) {
  return Container(
    decoration: HomeTheme.headerDecoration,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: provider.selectedType,
            items: provider.availableTypes.map((type) {
              return DropdownMenuItem<String>(
                value: type,
                child: Text(type[0].toUpperCase() + type.substring(1)),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) provider.filterByType(type);
            },
            underline: Container(height: 2, color: HomeTheme.primaryColor),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: HomeTheme.searchFieldDecoration,
            child: TextField(
              controller: _searchCtrl,
              decoration: HomeTheme.searchInputDecoration.copyWith(
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.grey[600]),
                        onPressed: () {
                          _searchCtrl.clear();
                          provider.searchPokemon('');
                        },
                      )
                    : null,
              ),
              onChanged: provider.searchPokemon,
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildPokemonGrid(PokemonProvider provider) {
    return Expanded(
      child: provider.loading
          ? Center(child: HomeTheme.loadingIndicator)
          : provider.filteredPokemons.isEmpty
              ? Center(child: HomeTheme.emptyState)
              : GridView.builder(
                  padding: HomeTheme.gridPadding,
                  gridDelegate: HomeTheme.gridDelegate,
                  itemCount: provider.filteredPokemons.length,
                  itemBuilder: (context, index) {
                    final pokemon = provider.filteredPokemons[index];
                    return PokemonCard(pokemon: pokemon);
                  },
                ),
    );
  }

  Widget _buildPagination(PokemonProvider provider, BuildContext context, bool isSmall) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isSmall ? 4 : 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: isSmall ? 16 : 20),
              onPressed: provider.currentPage > 1
                  ? () => provider.goToPage(provider.currentPage - 1)
                  : null,
            ),
            ...List.generate(provider.totalPages, (index) {
              final page = index + 1;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 1 : 2),
                child: InkWell(
                  onTap: () => provider.goToPage(page),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 10, vertical: isSmall ? 2 : 4),
                    decoration: BoxDecoration(
                      color: provider.currentPage == page
                          ? HomeTheme.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$page',
                      style: TextStyle(
                        color: provider.currentPage == page
                            ? Colors.white
                            : HomeTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmall ? 12 : 16,
                      ),
                    ),
                  ),
                ),
              );
            }),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: isSmall ? 16 : 20),
              onPressed: provider.currentPage < provider.totalPages
                  ? () => provider.goToPage(provider.currentPage + 1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonCard extends StatelessWidget {
  final dynamic pokemon; // Reemplaza con tu tipo PokemonEntity

  const PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final primaryType = pokemon.types.isNotEmpty ? pokemon.types[0] : 'normal';
    final typeColor = HomeTheme.getTypeColor(primaryType);

    return GestureDetector(
      onTap: () => _navigateToDetail(context),
      child: Container(
        decoration: HomeTheme.pokemonCardDecoration(typeColor),
        child: Stack(
          children: [
            _buildDecorativeCircle(),
            _buildCardContent(typeColor),
          ],
        ),
      ),
    );
  }

  Widget _buildDecorativeCircle() {
    return Positioned(
      right: -20,
      top: -20,
      child: Container(
        width: 100,
        height: 100,
        decoration: HomeTheme.decorativeCircleDecoration,
      ),
    );
  }

  Widget _buildCardContent(Color typeColor) {
    return Padding(
      padding: HomeTheme.cardPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPokemonImage(),
          SizedBox(height: 12),
          _buildPokemonName(),
          SizedBox(height: 8),
          _buildPokemonTypes(),
        ],
      ),
    );
  }

  Widget _buildPokemonImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: HomeTheme.imageContainerDecoration,
      child: ClipOval(
        child: Image.network(
          pokemon.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.catching_pokemon,
              size: 40,
              color: Colors.white,
            );
          },
        ),
      ),
    );
  }

  Widget _buildPokemonName() {
    return Text(
      pokemon.name.toUpperCase(),
      style: HomeTheme.pokemonNameStyle,
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPokemonTypes() {
    return Wrap(
      spacing: 4,
      children: pokemon.types.map<Widget>((type) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: HomeTheme.typeChipDecoration,
          child: Text(
            type,
            style: HomeTheme.typeTextStyle,
          ),
        );
      }).toList(),
    );
  }

  void _navigateToDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PokemonDetailScreen(pokemon: pokemon),
      ),
    );
  }
}