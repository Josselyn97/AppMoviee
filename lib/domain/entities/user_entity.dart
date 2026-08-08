class UserEntity {

  final int id;

  final String title;

  final String description;

  final String image;

  final String backdrop;

  final double rating;

  final String date;

  // movie o tv
  final String category;



  UserEntity({

    required this.id,

    required this.title,

    required this.description,

    required this.image,

    required this.backdrop,

    required this.rating,

    required this.date,

    required this.category,

  });


}