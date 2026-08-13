import '../entities/user_entity.dart';

abstract class UserRepository {

  Future<List<UserEntity>>
      getNowPlaying();

  Future<List<UserEntity>>
      getPopularMovies();

  Future<List<UserEntity>>
      getActionMovies();

  Future<List<UserEntity>>
      getFamilyMovies();

  Future<List<UserEntity>>
      getKidsMovies();

  Future<List<UserEntity>>
      getSeries();
}