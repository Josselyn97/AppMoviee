import 'package:dio/dio.dart';

import '../data/repositories/user_repository_impl.dart';
import '../data/services/api_service.dart';

class DependencyInjection {

  static final Dio dio = Dio();

  static final ApiService apiService =
      ApiService();

  static final UserRepositoryImpl
      userRepository =
          UserRepositoryImpl(
    apiService,
  );
}