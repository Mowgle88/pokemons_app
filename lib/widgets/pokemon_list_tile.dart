import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemons_app/models/pokemon.dart';
import 'package:pokemons_app/providers/pokemon_data_providers.dart';
import 'package:pokemons_app/widgets/pokemon_description_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  late FavoritePokemonProvider _favoritePokemonProvider;
  late List<String> _favoritePokemons;

  PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _favoritePokemonProvider = ref.watch(favoritePokemonProvider.notifier);
    _favoritePokemons = ref.watch(favoritePokemonProvider);

    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
      data: (data) => _tile(context, false, data),
      error: (error, stackTrace) => Text("Error $error"),
      loading: () => _tile(context, true, null),
    );
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    final isFavoritePokemon = _favoritePokemons.contains(pokemonUrl);
    return Skeletonizer(
      enabled: isLoading ? true : false,
      child: GestureDetector(
        onTap: () {
          if (!isLoading) {
            showDialog(
              context: context,
              builder: (context) {
                return PokemonDescriptionCard(pokemonUrl: pokemonUrl);
              },
            );
          }
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: pokemon != null
                ? NetworkImage(pokemon.sprites!.frontDefault!)
                : null,
          ),
          title: Text(
            pokemon?.name!.toUpperCase() ?? "Lsoading name for Pokemon",
          ),
          subtitle:
              Text("Has ${pokemon?.moves?.length.toString() ?? 0} movies"),
          trailing: IconButton(
            onPressed: () {
              if (isFavoritePokemon) {
                _favoritePokemonProvider.removeFavoritePokemon(pokemonUrl);
              } else {
                _favoritePokemonProvider.addFavoritePokemon(pokemonUrl);
              }
            },
            icon: Icon(
              isFavoritePokemon ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
