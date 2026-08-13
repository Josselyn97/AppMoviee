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





  Future<List<UserModel>> getNowPlaying() async {


    final response = await dio.get(

      '/movie/now_playing',

      queryParameters: {

        'api_key': apiKey,

        'language': 'es-ES',

      },

    );


    return (response.data['results'] as List)

        .map(

          (json) => UserModel.fromJson(json),

        )

        .toList();

  }





  Future<List<UserModel>> getPopularMovies() async {


    final response = await dio.get(

      '/movie/popular',

      queryParameters: {

        'api_key': apiKey,

        'language': 'es-ES',

      },

    );


    return (response.data['results'] as List)

        .map(

          (json) => UserModel.fromJson(json),

        )

        .toList();

  }






  Future<List<UserModel>> getActionMovies() async {


    final response = await dio.get(

      '/discover/movie',

      queryParameters: {

        'api_key': apiKey,

        'language': 'es-ES',

        'with_genres': 28,

      },

    );


    return (response.data['results'] as List)

        .map(

          (json) => UserModel.fromJson(json),

        )

        .toList();

  }






  Future<List<UserModel>> getFamilyMovies() async {


    final response = await dio.get(

      '/discover/movie',

      queryParameters: {

        'api_key': apiKey,

        'language': 'es-ES',

        'with_genres': 10751,

      },

    );


    return (response.data['results'] as List)

        .map(

          (json) => UserModel.fromJson(json),

        )

        .toList();

  }






  Future<List<UserModel>> getKidsMovies() async {


    final response = await dio.get(

      '/discover/movie',

      queryParameters: {

        'api_key': apiKey,

        'language': 'es-ES',

        'with_genres': 16,

      },

    );


    return (response.data['results'] as List)

        .map(

          (json) => UserModel.fromJson(json),

        )

        .toList();

  }






  Future<List<UserModel>> getSeries() async {


    final response = await dio.get(

      '/tv/popular',

      queryParameters: {

        'api_key': apiKey,

        'language': 'es-ES',

      },

    );


    return (response.data['results'] as List)

        .map(

          (json) => UserModel.fromJson(json),

        )

        .toList();

  }







  // ===============================
  // BUSQUEDA DE PELICULAS Y SERIES
  // ===============================


  Future<List<UserEntity>> searchMovies(

    String query,

  ) async {


    try {


      final response = await dio.get(


        '/search/multi',


        queryParameters: {


          'api_key': apiKey,


          'query': query,


          'language': 'es-ES',


          'include_adult': false,


        },


      );



      final List results =

          response.data['results'];



      return results

          .where(

            (json) =>

                json['media_type'] == 'movie'

                ||

                json['media_type'] == 'tv',

          )

          .map(

            (json) => UserModel.fromJson(json),

          )

          .toList();



    } catch(e) {


      print(

        "Error buscando películas: $e"

      );


      return [];

    }


  }







  // ===============================
  // OBTENER TRAILER YOUTUBE
  // ===============================


  Future<String?> getTrailerKey(

    int id,

    bool isMovie,

  ) async {


    try {


      final endpoint = isMovie

          ? '/movie/$id/videos'

          : '/tv/$id/videos';





      final response = await dio.get(


        endpoint,


        queryParameters: {


          'api_key': apiKey,


          'language': 'es-ES',


        },


      );




      print(response.data);




      final List videos =

          response.data['results'];





      for(var video in videos){


        if(

          video['site'] == 'YouTube'

          &&

          video['type'] == 'Trailer'

        ){


          return video['key'];


        }


      }




      return null;



    } catch(e){


      print(

        "Error obteniendo trailer: $e"

      );


      return null;


    }


  }



}