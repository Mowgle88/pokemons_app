import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemons_app/controllers/home_page_controller.dart';
import 'package:pokemons_app/models/page_data.dart';
import 'package:pokemons_app/models/pokemon.dart';
import 'package:pokemons_app/widgets/pokemon_list_tile.dart';

final homePageControllProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController(HomePageData.initial());
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late HomePageData _homePageData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _homePageData = ref.watch(homePageControllProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "All Pokemons",
                        style: TextStyle(fontSize: 25),
                      ),
                      SizedBox(
                        height: size.height * 0.6,
                        child: ListView.builder(
                          itemCount: _homePageData.data?.results?.length ?? 0,
                          itemBuilder: (context, index) {
                            PokemonListResult pokemon =
                                _homePageData.data!.results![index];
                            return PokemonListTile(pokemonUrl: pokemon.url!);
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}