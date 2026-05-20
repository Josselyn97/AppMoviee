import 'package:flutter/material.dart';

import '../views/detail_page.dart';
import '/../domain/entities/user_entity.dart';

class UserCard extends StatefulWidget {
  final UserEntity user;

  const UserCard({
    super.key,
    required this.user,
  });

  @override
  State<UserCard> createState() =>
      _UserCardState();
}

class _UserCardState
    extends State<UserCard> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () {

        Navigator.push(
          context,

          MaterialPageRoute(
            builder: (_) => DetailPage(
              user: widget.user,
            ),
          ),
        );
      },

      child: AnimatedScale(

        scale: isExpanded ? 1.02 : 1,

        duration: const Duration(
          milliseconds: 250,
        ),

        child: AnimatedContainer(

          duration: const Duration(
            milliseconds: 300,
          ),

          width: 320,

          margin: const EdgeInsets.only(
            right: 18,
          ),

          decoration: BoxDecoration(

            color: const Color(
              0xFF1E1E1E,
            ),

            borderRadius:
                BorderRadius.circular(28),

            boxShadow: [

              BoxShadow(
                color: Colors.black.withOpacity(
                  0.4,
                ),

                blurRadius: 15,

                offset: const Offset(
                  0,
                  8,
                ),
              ),
            ],
          ),

          child: Column(

            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              Stack(
                children: [

                  ClipRRect(

                    borderRadius:
                        const BorderRadius.vertical(
                      top: Radius.circular(
                        28,
                      ),
                    ),

                    child: Image.network(

                      'https://image.tmdb.org/t/p/w500${widget.user.image}',

                      height: 240,

                      width: double.infinity,

                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(

                    height: 240,

                    decoration: BoxDecoration(

                      borderRadius:
                          const BorderRadius.vertical(
                        top: Radius.circular(
                          28,
                        ),
                      ),

                      gradient:
                          LinearGradient(

                        begin:
                            Alignment.topCenter,

                        end:
                            Alignment.bottomCenter,

                        colors: [

                          Colors.transparent,

                          Colors.black.withOpacity(
                            0.85,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(

                    top: 16,
                    left: 16,

                    child: Container(

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),

                      decoration:
                          BoxDecoration(

                        color: Colors.redAccent,

                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: const Text(

                        '🎬 Popular',

                        style: TextStyle(

                          color: Colors.white,

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),

                  Positioned(

                    bottom: 16,
                    left: 16,
                    right: 16,

                    child: Text(

                      widget.user.title,

                      maxLines: 1,

                      overflow:
                          TextOverflow.fade,

                      softWrap: false,

                      style: const TextStyle(

                        color: Colors.white,

                        fontSize: 24,

                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              Padding(

                padding:
                    const EdgeInsets.all(16),

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Row(
                      children: [

                        Container(

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),

                          decoration:
                              BoxDecoration(

                            color: Colors.amber
                                .withOpacity(
                              0.15,
                            ),

                            borderRadius:
                                BorderRadius.circular(
                              20,
                            ),
                          ),

                          child: Row(
                            children: [

                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),

                              const SizedBox(
                                width: 5,
                              ),

                              Text(

                                widget.user.rating
                                    .toStringAsFixed(
                                  1,
                                ),

                                style:
                                    const TextStyle(

                                  color: Colors.white,

                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        Row(
                          children: [

                            const Icon(
                              Icons.calendar_month,
                              color: Colors.white54,
                              size: 18,
                            ),

                            const SizedBox(
                              width: 5,
                            ),

                            SizedBox(

                              width: 80,

                              child: Text(

                                widget.user.date,

                                overflow:
                                    TextOverflow.ellipsis,

                                style:
                                    const TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    GestureDetector(

                      onTap: () {

                        setState(() {

                          isExpanded =
                              !isExpanded;
                        });
                      },

                      child: Row(
                        children: [

                          Icon(

                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,

                            color: Colors.redAccent,
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          Text(

                            isExpanded
                                ? 'Ocultar detalles'
                                : 'Ver detalles',

                            style:
                                const TextStyle(

                              color: Colors.redAccent,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    AnimatedCrossFade(

                      duration:
                          const Duration(
                        milliseconds: 300,
                      ),

                      crossFadeState:
                          isExpanded
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,

                      firstChild: Text(

                        widget.user.description,

                        maxLines: 4,

                        overflow:
                            TextOverflow.ellipsis,

                        style: const TextStyle(

                          color: Colors.white70,

                          height: 1.5,

                          fontSize: 14,
                        ),
                      ),

                      secondChild:
                          const SizedBox(),
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