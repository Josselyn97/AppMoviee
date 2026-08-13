import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '/../domain/entities/user_entity.dart';
import '../widgets/user_card.dart';

class CategoryPage extends StatelessWidget {
  final String title;

  final List<UserEntity> users;

  const CategoryPage({
    super.key,
    required this.title,
    required this.users,
  });

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
        title: Text(
          title,

          style:
              GoogleFonts.poppins(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(
          16,
        ),

        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          childAspectRatio: 0.58,

          crossAxisSpacing: 16,

          mainAxisSpacing: 16,
        ),

        itemCount: users.length,

        itemBuilder: (
          context,
          index,
        ) {
          return UserCard(
            userEntity: users[index],
          );

        },
      ),
    );
  }
}