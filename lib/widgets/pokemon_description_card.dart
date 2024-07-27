import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemons_app/providers/pokemon_data_providers.dart';

class PokemonDescriptionCard extends ConsumerWidget {
  final String pokemonUrl;

  const PokemonDescriptionCard({
    super.key,
    required this.pokemonUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(pokemonDataProvider(pokemonUrl));

    return AlertDialog(
      title: const Text("Description"),
      content: pokemon.when(
        data: (data) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              data!.sprites!.frontDefault!,
              scale: 0.12,
            ),
            ...data.stats
                    ?.map((s) =>
                        Text("${s.stat?.name?.toUpperCase()}: ${s.baseStat}"))
                    .toList() ??
                []
          ],
        ),
        error: (error, stackTrace) => Text(error.toString()),
        loading: () => const CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
