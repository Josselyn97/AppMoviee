import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/presentation/viewmodels/user_view_model.dart';
import 'data/presentation/views/home_page.dart';
import 'data/presentation/views/login_page.dart'; // Corrección de nombre de archivo
import 'data/presentation/views/register_page.dart'; 
import 'data/presentation/views/search_page.dart'; 
import 'core/dependency_injection.dart';
import 'data/presentation/views/detail_page.dart';
import 'domain/entities/user_entity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(
        DependencyInjection.userRepository,
      ),
      child: MaterialApp(
        title: 'Users App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),

        initialRoute: '/',

        routes: {
          '/': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/home': (context) => const HomePage(),
          '/search': (context) => const SearchPage(),
        },

        onGenerateRoute: (settings) {
          if (settings.name == '/detail') {
            final movie = settings.arguments as UserEntity;

            return MaterialPageRoute(
              builder: (_) => DetailPage(
                user: movie,
              ),
            );
          }

          return null;
        },
      )
    );
  }
}
