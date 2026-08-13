import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {

  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(

        backgroundColor:
            const Color(0xFF121212),

        elevation: 0,

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

          'Mi Perfil',

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Center(

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                boxShadow: [

                  BoxShadow(

                    color: Colors.redAccent
                        .withOpacity(0.5),

                    blurRadius: 25,
                  ),
                ],
              ),

              child: const CircleAvatar(

                radius: 70,

                backgroundImage:
                    NetworkImage(

                  'https://i.pravatar.cc/300',
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            const Text(

              'Movie Lover',

              style: TextStyle(

                color: Colors.white,

                fontSize: 28,

                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(

              'Explorando películas y series 🎬',

              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(
              height: 40,
            ),

            Container(

              margin:
                  const EdgeInsets.symmetric(
                horizontal: 30,
              ),

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(

                color: Colors.white10,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),
              ),

              child: const Column(
                children: [

                  ListTile(

                    leading: Icon(
                      Icons.favorite,
                      color: Colors.redAccent,
                    ),

                    title: Text(
                      'Películas favoritas',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),

                  Divider(
                    color: Colors.white24,
                  ),

                  ListTile(

                    leading: Icon(
                      Icons.tv,
                      color: Colors.blueAccent,
                    ),

                    title: Text(
                      'Series vistas',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}