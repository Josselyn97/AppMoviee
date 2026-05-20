import 'package:flutter/material.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '/../domain/entities/user_entity.dart';

import '/../data/services/api_service.dart';

class DetailPage extends StatefulWidget {

  final UserEntity user;

  const DetailPage({
    super.key,
    required this.user,
  });

  @override
  State<DetailPage> createState() =>
      _DetailPageState();
}

class _DetailPageState
    extends State<DetailPage> {

  final ApiService apiService =
      ApiService();

  YoutubePlayerController?
      controller;

  bool isLoading = true;

  @override
  void initState() {

    super.initState();

    loadTrailer();
  }

  Future<void> loadTrailer() async {

    final key =
        await apiService.getTrailerKey(
      widget.user.id,
    );

    if (key != null) {

      controller =
          YoutubePlayerController(

        initialVideoId: key,

        flags:
            const YoutubePlayerFlags(

          autoPlay: false,

          mute: false,
        ),
      );
    }

    setState(() {

      isLoading = false;
    });
  }

  @override
  void dispose() {

    controller?.dispose();

    super.dispose();
  }

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

        title: Text(

          widget.user.title,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Image.network(

              'https://image.tmdb.org/t/p/w500${widget.user.image}',

              width: double.infinity,

              height: 350,

              fit: BoxFit.cover,
            ),

            Padding(

              padding:
                  const EdgeInsets.all(20),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(

                    widget.user.title,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(

                        widget.user.rating
                            .toStringAsFixed(1),

                        style:
                            const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(

                    widget.user.description,

                    style: const TextStyle(

                      color: Colors.white70,

                      fontSize: 16,

                      height: 1.6,
                    ),
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const Text(

                    '🎥 Trailer',

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 22,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  if (isLoading)

                    const Center(
                      child:
                          CircularProgressIndicator(),
                    )

                  else if (controller != null)

                    YoutubePlayer(

                      controller:
                          controller!,

                      showVideoProgressIndicator:
                          true,
                    )

                  else

                    const Text(

                      'No hay trailer disponible',

                      style: TextStyle(
                        color: Colors.white70,
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