import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/../domain/entities/user_entity.dart';

import '../viewmodels/user_view_model.dart';
import '../widgets/user_card.dart';

import 'category_page.dart';
import 'search_page.dart';
import 'profile_page.dart';
import 'menu_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState
    extends State<HomePage> {
  int selectedCategory = 0;

  int bottomIndex = 0;

  final List<String> categories = [
    'Todos',
    'Acción',
    'Familiar',
    'Infantil',
    'Series',
  ];

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<UserViewModel>()
          .fetchData();
    });
  }

  Widget buildCategoryChip(
    String title,
    int index,
  ) {
    final isSelected =
        selectedCategory == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 300,
        ),

        margin: const EdgeInsets.only(
          right: 12,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: isSelected
              ? Colors.redAccent
              : Colors.white10,

          borderRadius:
              BorderRadius.circular(30),
        ),

        child: Text(
          title,

          style: TextStyle(
            color: isSelected
                ? Colors.white
                : Colors.white70,

            fontWeight:
                FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget buildSection(
    String title,
    List<UserEntity> users,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
          ),

          child: Row(
            children: [
              Text(
                title,

                style:
                    GoogleFonts.poppins(
                  fontSize: 24,

                  fontWeight:
                      FontWeight.bold,

                  color: Colors.white,
                ),
              ),

              const Spacer(),

              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          CategoryPage(
                        title: title,
                        users: users,
                      ),
                    ),
                  );
                },

                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white54,
                  size: 18,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        SizedBox(
          height: 390,

          child: ListView.builder(
            scrollDirection:
                Axis.horizontal,

            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            itemCount: users.length,

            itemBuilder: (
              context,
              index,
            ) {
              return TweenAnimationBuilder(
                duration: Duration(
                  milliseconds:
                      300 +
                      (index * 100),
                ),

                tween: Tween(
                  begin: 0.0,
                  end: 1.0,
                ),

                builder: (
                  context,
                  value,
                  child,
                ) {
                  return Opacity(
                    opacity: value,

                    child:
                        Transform.translate(
                      offset: Offset(
                        40 * (1 - value),
                        0,
                      ),

                      child: child,
                    ),
                  );
                },

                child: UserCard(
                  user: users[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 28),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<UserViewModel>(
      context,
    );

    return Scaffold(
      backgroundColor:
          const Color(0xFF121212),

      appBar: AppBar(
        backgroundColor:
            const Color(0xFF121212),

        elevation: 0,

        centerTitle: true,

        title: Text(
          'Movie Explorer',

          style: GoogleFonts.poppins(
            fontSize: 30,

            fontWeight:
                FontWeight.bold,

            color: Colors.white,
          ),
        ),
      ),

      bottomNavigationBar:
          BottomNavigationBar(
        backgroundColor:
            const Color(0xFF1A1A1A),

        selectedItemColor:
            Colors.redAccent,

        unselectedItemColor:
            Colors.white54,

        currentIndex: bottomIndex,

        onTap: (index) {
          setState(() {
            bottomIndex = index;
          });

          if (index == 1) {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    const SearchPage(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    const ProfilePage(),
              ),
            );
          }

          if (index == 3) {
            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (_) =>
                    const MenuPage(),
              ),
            );
          }
        },

        type:
            BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menú',
          ),
        ],
      ),

      body: viewModel.isLoading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : viewModel
                  .errorMessage
                  .isNotEmpty
              ? Center(
                  child: Text(
                    viewModel.errorMessage,

                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : Column(
                  children: [
                    // BANNER SUPERIOR FIJO
                    Container(
                      height: 80,
                      padding:
                          const EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),

                      child: ListView.builder(
                        scrollDirection:
                            Axis.horizontal,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),

                        itemCount:
                            categories.length,

                        itemBuilder:
                            (
                              context,
                              index,
                            ) {
                          return buildCategoryChip(
                            categories[index],
                            index,
                          );
                        },
                      ),
                    ),

                    // CONTENIDO
                    Expanded(
                      child:
                          RefreshIndicator(
                        onRefresh:
                            () async {
                          await viewModel
                              .fetchData();
                        },

                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),

                            if (selectedCategory ==
                                0) ...[
                              buildSection(
                                '🎬 Estrenos',
                                viewModel
                                    .nowPlaying,
                              ),

                              buildSection(
                                '🔥 Acción',
                                viewModel
                                    .actionMovies,
                              ),

                              buildSection(
                                '👨‍👩‍👧 Familiar',
                                viewModel
                                    .familyMovies,
                              ),

                              buildSection(
                                '🧸 Infantil',
                                viewModel
                                    .kidsMovies,
                              ),

                              buildSection(
                                '📺 Series',
                                viewModel
                                    .series,
                              ),
                            ],

                            if (selectedCategory ==
                                1)
                              buildSection(
                                '🔥 Acción',
                                viewModel
                                    .actionMovies,
                              ),

                            if (selectedCategory ==
                                2)
                              buildSection(
                                '👨‍👩‍👧 Familiar',
                                viewModel
                                    .familyMovies,
                              ),

                            if (selectedCategory ==
                                3)
                              buildSection(
                                '🧸 Infantil',
                                viewModel
                                    .kidsMovies,
                              ),

                            if (selectedCategory ==
                                4)
                              buildSection(
                                '📺 Series',
                                viewModel
                                    .series,
                              ),

                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
    );
  }
}