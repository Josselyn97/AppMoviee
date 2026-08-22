import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/user_repository.dart';

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

  bool authLoading = false;

  final String _apiUrl = 'https://railway.app';

  Map<String, dynamic>? _currentUser;
  Map<String, dynamic>? get currentUser => _currentUser;

  Future<bool> loginUser(String email, String password) async {
    authLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      authLoading = false;
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = data['user']; 
        notifyListeners();
        return true;
      }
      
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint('Error en Login: $e');
      authLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> registerUser(String name, String email, String password) async {
    authLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );

      authLoading = false;
      notifyListeners();
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error en Registro: $e');
      authLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      final results = await Future.wait([
        repository.getNowPlaying(),
        repository.getActionMovies(),
        repository.getFamilyMovies(),
        repository.getKidsMovies(),
        repository.getSeries(),
      ]);

      nowPlaying = results[0];
      actionMovies = results[1];
      familyMovies = results[2];
      kidsMovies = results[3];
      series = results[4];

      errorMessage = '';
    } catch (e) {
      errorMessage = "No se pudieron cargar las películas";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void logoutUser(BuildContext context) {
    _currentUser = null; 
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
