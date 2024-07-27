import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemons_app/controllers/home_page_controller.dart';
import 'package:pokemons_app/models/page_data.dart';
import 'package:pokemons_app/models/pokemon.dart';
import 'package:pokemons_app/providers/pokemon_data_providers.dart';
import 'package:pokemons_app/widgets/pokemon_card.dart';
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
  final ScrollController _allPokemonListScrollController = ScrollController();

  late HomePageController _homePageController;
  late HomePageData _homePageData;

  late List<String> _favoritePokemons;

  @override
  void initState() {
    super.initState();
    _allPokemonListScrollController.addListener(_scrollListenr);
  }

  @override
  void dispose() {
    _allPokemonListScrollController.removeListener(_scrollListenr);
    _allPokemonListScrollController.dispose();
    super.dispose();
  }

  void _scrollListenr() {
    if (_allPokemonListScrollController.offset >=
            _allPokemonListScrollController.position.maxScrollExtent * 1 &&
        !_allPokemonListScrollController.position.outOfRange) {
      print("Reach end of list");
      _homePageController.loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _homePageController = ref.watch(homePageControllProvider.notifier);
    _homePageData = ref.watch(homePageControllProvider);
    _favoritePokemons = ref.watch(favoritePokemonProvider);

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
                _favoritePokemonsList(context, size),
                _allPokemons(context, size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _favoritePokemonsList(BuildContext context, Size size) {
    return SizedBox(
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favorites",
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(
            width: size.width,
            height: size.height * 0.5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_favoritePokemons.isNotEmpty)
                  SizedBox(
                    height: size.height * 0.48,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: _favoritePokemons.length,
                        itemBuilder: (context, index) {
                          String pokemonUrl = _favoritePokemons[index];
                          return PokemonCard(pokemonUrl: pokemonUrl);
                        }),
                  ),
                if (_favoritePokemons.isEmpty)
                  const Text("No favorite pokemons yet1 ;(")
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _allPokemons(BuildContext context, Size size) {
    return SizedBox(
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
              controller: _allPokemonListScrollController,
              itemCount: _homePageData.data?.results?.length ?? 0,
              itemBuilder: (context, index) {
                PokemonListResult pokemon = _homePageData.data!.results![index];
                return PokemonListTile(pokemonUrl: pokemon.url!);
              },
            ),
          )
        ],
      ),
    );
  }
}
