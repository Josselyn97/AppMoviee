import 'package:flutter/material.dart';
import '../../../domain/entities/user_entity.dart';

class UserCard extends StatelessWidget {

  final UserEntity userEntity;

  const UserCard({
    super.key,
    required this.userEntity,
  });

  @override
Widget build(BuildContext context) {

  final imageUrl = userEntity.image.isNotEmpty
      ? 'https://image.tmdb.org/t/p/w500${userEntity.image}'
      : 'https://via.placeholder.com/500x750?text=Sin+Imagen';

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(
        context,
        '/detail',
        arguments: userEntity,
      );
    },
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 180,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.45),
            blurRadius: 12,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [

            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    color: Colors.grey.shade900,
                    child: const Icon(
                      Icons.movie,
                      color: Colors.white30,
                      size: 70,
                    ),
                  );
                },
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),

                      const SizedBox(width: 4),

                      Text(
                        userEntity.rating.toStringAsFixed(1).toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    userEntity.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    userEntity.date,
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
