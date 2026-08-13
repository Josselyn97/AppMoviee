import 'package:dio/dio.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';

import '../services/api_service.dart';

class UserRepositoryImpl
    implements UserRepository {

  final ApiService apiService;

  UserRepositoryImpl(
    this.apiService,
  );

  @override
  Future<List<UserEntity>>
      getNowPlaying() async {

    try {

      return await apiService
          .getNowPlaying();

    } on DioException catch (e) {

      throw Exception(
        _handleError(e),
      );
    }
  }

  @override
  Future<List<UserEntity>>
      getPopularMovies() async {

    try {

      return await apiService
          .getPopularMovies();

    } on DioException catch (e) {

      throw Exception(
        _handleError(e),
      );
    }
  }

  @override
  Future<List<UserEntity>>
      getActionMovies() async {

    try {

      return await apiService
          .getActionMovies();

    } on DioException catch (e) {

      throw Exception(
        _handleError(e),
      );
    }
  }

  @override
  Future<List<UserEntity>>
      getFamilyMovies() async {

    try {

      return await apiService
          .getFamilyMovies();

    } on DioException catch (e) {

      throw Exception(
        _handleError(e),
      );
    }
  }

  @override
  Future<List<UserEntity>>
      getKidsMovies() async {

    try {

      return await apiService
          .getKidsMovies();

    } on DioException catch (e) {

      throw Exception(
        _handleError(e),
      );
    }
  }

  @override
  Future<List<UserEntity>>
      getSeries() async {

    try {

      return await apiService
          .getSeries();

    } on DioException catch (e) {

      throw Exception(
        _handleError(e),
      );
    }
  }

  String _handleError(
    DioException e,
  ) {

    if (e.response?.statusCode ==
        404) {

      return
          'Error 404: No encontrado';
    }

    if (e.response?.statusCode ==
        500) {

      return
          'Error 500: Error del servidor';
    }

    return 'Sin conexión a internet';
  }
}