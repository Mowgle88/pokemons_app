import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pokemons_app/models/pokemon.dart';
import 'package:pokemons_app/services/database_service.dart';
import 'package:pokemons_app/services/http_service.dart';

final pokemonDataProvider = FutureProvider.family<Pokemon?, String>(
  (ref, url) async {
    HTTPService _httpService = GetIt.instance.get<HTTPService>();
    Response? res = await _httpService.get(
      url,
    );

    if (res != null && res.data != null) {
      return Pokemon.fromJson(res.data);
    }
  },
);

final favoritePokemonProvider =
    StateNotifierProvider<FavoritePokemonProvider, List<String>>((ref) {
  return FavoritePokemonProvider([]);
});

class FavoritePokemonProvider extends StateNotifier<List<String>> {
  FavoritePokemonProvider(super.state) {
    _setup();
  }

  final DatabaseService databaseService = GetIt.instance.get<DatabaseService>();

  String favoritePokemonLisstKey = "FAVORITE_POKEMON_LIST_KEY";

  Future<void> _setup() async {
    List<String>? result =
        await databaseService.getList(favoritePokemonLisstKey);
    state = result ?? [];
  }

  void addFavoritePokemon(String url) {
    state = [...state, url];
    databaseService.saveList(favoritePokemonLisstKey, state);
  }

  void removeFavoritePokemon(String url) {
    state = state.where((pokemon) => pokemon != url).toList();
    databaseService.saveList(favoritePokemonLisstKey, state);
  }
}
