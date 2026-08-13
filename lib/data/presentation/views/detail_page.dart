import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../domain/entities/user_entity.dart';
import '../../services/api_service.dart';


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


  YoutubePlayerController? controller;


  bool isLoading = true;


  String? trailerKey;



  @override
  void initState() {

    super.initState();

    loadTrailer();

  }




  Future<void> loadTrailer() async {


    try {


      final key =
          await apiService.getTrailerKey(

        widget.user.id,

        widget.user.category == 'movie',

      );



      if(key != null) {


        trailerKey = key;



        controller =
           YoutubePlayerController(

          initialVideoId: key,

          flags:
              const YoutubePlayerFlags(

            autoPlay: false,

            mute: true,

            enableCaption: false,

          ),

        );

      }



    } catch(e) {


      debugPrint(
        "Error cargando trailer: $e"
      );


    }



    if(mounted){

      setState(() {

        isLoading = false;

      });

    }


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


        leading:
            IconButton(


          icon:
              const Icon(

            Icons.arrow_back,

            color: Colors.white,

          ),



          onPressed: () {

            Navigator.pop(context);

          },

        ),



        title: Text(

          widget.user.title,


          style:
              const TextStyle(

            color: Colors.white,

          ),

        ),

      ),





      body:
          SingleChildScrollView(


        child:
            Column(


          crossAxisAlignment:
              CrossAxisAlignment.start,


          children: [



            Image.network(


              'https://image.tmdb.org/t/p/w780${widget.user.backdrop}',


              width:
                  double.infinity,


              height:
                  260,


              fit:
                  BoxFit.cover,



              errorBuilder:
                  (context, error, stackTrace){

                return Container(

                  height:260,

                  color: Colors.black26,

                  child:
                      const Center(

                    child:
                        Icon(

                      Icons.movie,

                      color: Colors.white54,

                      size:60,

                    ),

                  ),

                );

              },

            ),





            Padding(


              padding:
                  const EdgeInsets.all(20),



              child:
                  Column(


                crossAxisAlignment:
                    CrossAxisAlignment.start,



                children: [





                  Text(

                    widget.user.title,


                    style:
                        const TextStyle(


                      color: Colors.white,


                      fontSize: 28,


                      fontWeight:
                          FontWeight.bold,


                    ),

                  ),





                  const SizedBox(
                    height:15,
                  ),





                  Row(

                    children: [


                      const Icon(

                        Icons.star,

                        color:
                            Colors.amber,

                      ),



                      const SizedBox(
                        width:5,
                      ),




                      Text(

                        widget.user.rating
                            .toStringAsFixed(1),



                        style:
                            const TextStyle(

                          color:
                              Colors.white,

                        ),

                      ),


                    ],

                  ),





                  const SizedBox(
                    height:20,
                  ),





                  Text(

                    widget.user.description,


                    style:
                        const TextStyle(

                      color:
                          Colors.white70,


                      fontSize:16,


                      height:1.6,

                    ),

                  ),





                  const SizedBox(
                    height:30,
                  ),






                  const Text(

                    '🎬 Trailer',

                    style:
                        TextStyle(

                      color:
                          Colors.white,


                      fontSize:22,


                      fontWeight:
                          FontWeight.bold,

                    ),

                  ),





                  const SizedBox(
                    height:15,
                  ),






                  if(isLoading)

                    const Center(

                      child:
                          CircularProgressIndicator(),

                    )





                  else if(controller != null)



                    Column(

                      children: [


                        ElevatedButton.icon(

                          onPressed: (){


                            controller!.play();


                          },


                          icon:
                              const Icon(

                            Icons.play_circle_fill,

                          ),



                          label:
                              const Text(

                            "Ver Trailer",

                          ),

                        ),




                        const SizedBox(
                          height:20,
                        ),





                        YoutubePlayerBuilder(

                          player: YoutubePlayer(

                            controller: controller!,

                            showVideoProgressIndicator: true,

                          ),

                          builder: (context, player){

                            return player;

                          },

                        )


                      ],

                    )






                  else


                    Container(


                      padding:
                          const EdgeInsets.all(15),



                      decoration:
                          BoxDecoration(


                        color:
                            Colors.white10,


                        borderRadius:
                            BorderRadius.circular(10),


                      ),



                      child:
                          const Text(


                        'No hay trailer disponible para este contenido',



                        style:
                            TextStyle(

                          color:
                              Colors.white70,


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