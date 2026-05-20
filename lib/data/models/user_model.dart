import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.title,
    required super.description,
    required super.image,
    required super.rating,
    required super.date,
    required super.category,
  });

  factory UserModel.fromJson(
  Map<String, dynamic> json,
) {

  return UserModel(

    id: json['id'] ?? 0,

    title:
        json['title'] ??
        json['name'] ??
        'Sin título',

    description:
        json['overview'] ?? '',

    image:
        json['poster_path'] ?? '',

    rating:
        (json['vote_average'] ?? 0)
            .toDouble(),

    date:
        json['release_date'] ??
        json['first_air_date'] ??
        '',

    category:
        json['media_type'] ??
        'Película',
  );
}
}