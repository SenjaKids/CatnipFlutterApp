import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zladag_flutter_app/features/user/data/models/sub_models.dart';
import 'package:zladag_flutter_app/features/user/data/models/user_model.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

import '../../../../../core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<void>? cacheUser(UserModel? userToCache);
  Future<void>? cachePets(List<PetEntity> petsToCache);
  Future<void>? cacheAccessToken(String? accessToken);

  Future<UserModel> getLastUser();
  Future<List<PetModel>> getLastPets();
  Future<String> getLastAccessToken();
}

const cachedUser = 'CACHED_USER';
const cachedPets = 'CACHED_PETS';
const cachedAccessToken = 'CACHED_ACCESS_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void>? cacheUser(UserModel? userToCache) async {
    if (userToCache != null) {
      sharedPreferences.setString(
        cachedUser,
        json.encode(
          userToCache.toJson(),
        ),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<UserModel> getLastUser() {
    final jsonString = sharedPreferences.getString(cachedUser);

    if (jsonString != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cacheAccessToken(String? accessToken) async {
    if (accessToken != null) {
      sharedPreferences.setString(
        cachedAccessToken,
        accessToken,
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<String> getLastAccessToken() {
    final accessToken = sharedPreferences.getString(cachedAccessToken);

    if (accessToken != null) {
      return Future.value(accessToken);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cachePets(List<PetEntity>? petsToCache) async {
    // if (petsToCache != null){

    // }
    PetModels petModels = PetModels();
    petModels.petEntities = [];

    if (petsToCache != null) {
      for (PetEntity pet in petsToCache) {
        petModels.petEntities!.add(pet);
      }
      sharedPreferences.setString(
        cachedPets,
        json.encode(
          petModels.toJson(),
        ),
      );
    } else {
      throw CacheException();
    }
  }

  @override
  Future<List<PetModel>> getLastPets() {
    // TODO: implement getLastPets
    throw UnimplementedError();
  }

  // @override
  // Future<PokemonModel> getLastPokemon() {
  //   final jsonString = sharedPreferences.getString(cachedPokemon);

  //   if (jsonString != null) {
  //     return Future.value(PokemonModel.fromJson(json.decode(jsonString)));
  //   } else {
  //     throw CacheException();
  //   }
  // }

  // @override
  // Future<void>? cachePokemon(PokemonModel? pokemonToCache) async {

  //   if (pokemonToCache != null) {
  //     sharedPreferences.setString(
  //       cachedPokemon,
  //       json.encode(
  //         pokemonToCache.toJson(),
  //       ),
  //     );
  //   } else {
  //     throw CacheException();
  //   }
  // }
}
