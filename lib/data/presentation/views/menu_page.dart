import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF121212),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),

          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Menú',
        ),
      ),

      body: ListView(
        children: const [
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Colors.white,
            ),

            title: Text(
              'Configuración',

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.white,
            ),

            title: Text(
              'Favoritos',

              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}