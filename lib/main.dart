import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/presentation/viewmodels/user_view_model.dart';
import '../data/presentation/views/home_page.dart';
import 'core/dependency_injection.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserViewModel(
        DependencyInjection
            .userRepository,
      ),

      child: MaterialApp(

        title: 'Users App',

        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),

        home: const HomePage(),
      ),
    );
  }
}