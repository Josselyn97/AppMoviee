import '../../domain/entities/user_entity.dart';


class UserModel extends UserEntity {


  UserModel({

    required super.id,

    required super.title,

    required super.description,

    required super.image,

    required super.backdrop,

    required super.rating,

    required super.date,

    required super.category,

  });




  factory UserModel.fromJson(Map<String, dynamic> json) {


    return UserModel(


      id: json['id'] ?? 0,



      title:
          json['title']
          ??
          json['name']
          ??
          'Sin título',




      description:
          json['overview']
          ??
          'Sin descripción',




      image:
          json['poster_path']
          ??
          '',




      backdrop:
          json['backdrop_path']
          ??
          '',




      rating:
          (json['vote_average'] ?? 0)
          .toDouble(),




      date:
          json['release_date']
          ??
          json['first_air_date']
          ??
          '',




      category:

          // Si TMDB manda media_type lo usa
          // Si no, detecta por los campos

          json['media_type']
          ??
          (
            json.containsKey('title')
              ? 'movie'
              : 'tv'
          ),


    );


  }


}