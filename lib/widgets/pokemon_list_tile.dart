import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemons_app/models/pokemon.dart';
import 'package:pokemons_app/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonListTile({super.key, required this.pokemonUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));
    return pokemon.when(
      data: (data) => _tile(context, false, data),
      error: (error, stackTrace) => Text("Error $error"),
      loading: () => _tile(context, true, null),
    );
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading ? true : false,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: pokemon != null
              ? NetworkImage(pokemon.sprites!.frontDefault!)
              : null,
        ),
        title: Text(
          pokemon?.name!.toUpperCase() ?? "Lsoading name for Pokemon",
        ),
        subtitle: Text("Has ${pokemon?.moves?.length.toString() ?? 0} movies"),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.favorite_border),
        ),
      ),
    );
  }
}
