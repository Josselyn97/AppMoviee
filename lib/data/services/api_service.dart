import 'package:dio/dio.dart';

import '../models/user_model.dart';
import '../../domain/entities/user_entity.dart';

class ApiService {

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
    ),
  );

  final String apiKey =
      '1d184961caab28bb08c49e7f1eb4a2a0';

  Future<List<UserModel>>
      getNowPlaying() async {

    final response = await dio.get(
      '/movie/now_playing',

      queryParameters: {
        'api_key': apiKey,
        'language': 'es-ES',
      },
    );

    return (response.data['results']
            as List)
        .map(
          (json) =>
              UserModel.fromJson(json),
        )
        .toList();
  }

  Future<List<UserModel>>
      getPopularMovies() async {

    final response = await dio.get(
      '/movie/popular',

      queryParameters: {
        'api_key': apiKey,
        'language': 'es-ES',
      },
    );

    return (response.data['results']
            as List)
        .map(
          (json) =>
              UserModel.fromJson(json),
        )
        .toList();
  }

  Future<List<UserModel>>
      getActionMovies() async {

    final response = await dio.get(
      '/discover/movie',

      queryParameters: {
        'api_key': apiKey,
        'language': 'es-ES',
        'with_genres': 28,
      },
    );

    return (response.data['results']
            as List)
        .map(
          (json) =>
              UserModel.fromJson(json),
        )
        .toList();
  }

  Future<List<UserModel>>
      getFamilyMovies() async {

    final response = await dio.get(
      '/discover/movie',

      queryParameters: {
        'api_key': apiKey,
        'language': 'es-ES',
        'with_genres': 10751,
      },
    );

    return (response.data['results']
            as List)
        .map(
          (json) =>
              UserModel.fromJson(json),
        )
        .toList();
  }

  Future<List<UserModel>>
      getKidsMovies() async {

    final response = await dio.get(
      '/discover/movie',

      queryParameters: {
        'api_key': apiKey,
        'language': 'es-ES',
        'with_genres': 16,
      },
    );

    return (response.data['results']
            as List)
        .map(
          (json) =>
              UserModel.fromJson(json),
        )
        .toList();
  }

  Future<List<UserModel>>
      getSeries() async {

    final response = await dio.get(
      '/tv/popular',

      queryParameters: {
        'api_key': apiKey,
        'language': 'es-ES',
      },
    );

    return (response.data['results']
            as List)
        .map(
          (json) =>
              UserModel.fromJson(json),
        )
        .toList();
  }

  Future<List<UserEntity>>
    searchMovies(
  String query,
) async {

  final response =
      await dio.get(

    '/search/movie',

    queryParameters: {

      'api_key': apiKey,

      'query': query,

      'language': 'es-ES',
    },
  );

  final List results =
      response.data['results'];

  return results
      .map(
        (json) =>
            UserModel.fromJson(json),
      )
      .toList();
}
Future<String?> getTrailerKey(
  int movieId,
) async {

  final response = await dio.get(

    '/movie/$movieId/videos',

    queryParameters: {

      'api_key': apiKey,

      'language': 'es-ES',
    },
  );

  final List results =
      response.data['results'];

  if (results.isEmpty) {
    return null;
  }

  final trailer = results.firstWhere(

    (video) =>
        video['site'] == 'YouTube' &&
        video['type'] == 'Trailer',

    orElse: () => null,
  );

  if (trailer == null) {
    return null;
  }

  return trailer['key'];
}
}