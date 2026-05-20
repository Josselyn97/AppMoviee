import 'package:flutter/material.dart';

import '/../domain/entities/user_entity.dart';
import '/../domain/repositories/user_repository.dart';

class UserViewModel extends ChangeNotifier {

  final UserRepository repository;

  UserViewModel(this.repository);

  bool isLoading = false;

  String errorMessage = '';

  List<UserEntity> nowPlaying = [];

  List<UserEntity> popularMovies = [];

  List<UserEntity> popularTv = [];

  List<UserEntity> familyMovies = [];

  List<UserEntity> kidsMovies = [];

  List<UserEntity> actionMovies = [];

  List<UserEntity> series = [];

  Future<void> fetchData() async {

    try {
      isLoading = true;

      notifyListeners();

      nowPlaying =
          await repository.getNowPlaying();

      actionMovies =
          await repository.getActionMovies();

      familyMovies =
          await repository.getFamilyMovies();

      kidsMovies =
          await repository.getKidsMovies();

      series =
          await repository.getSeries();

      errorMessage = '';

    } catch (e) {

      debugPrint(
        'ERROR REAL: $e',
      );

      errorMessage =
          'Error al cargar películas';
    } finally {

      isLoading = false;

      notifyListeners();
    }
  }
}