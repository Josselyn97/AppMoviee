import 'package:flutter/material.dart';

import '/../domain/entities/user_entity.dart';

import '/../data/services/api_service.dart';

import '../widgets/user_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() =>
      _SearchPageState();
}

class _SearchPageState
    extends State<SearchPage> {

  final TextEditingController
      searchController =
          TextEditingController();

  final ApiService apiService =
      ApiService();

  List<UserEntity> results = [];

  bool isLoading = false;

  Future<void> searchMovie(
    String query,
  ) async {

    if (query.isEmpty) {

      setState(() {

        results = [];
      });

      return;
    }

    setState(() {

      isLoading = true;
    });

    try {

      final response =
          await apiService
              .searchMovies(query);

      setState(() {

        results = response;
      });

    } catch (e) {

      setState(() {

        results = [];
      });
    }

    setState(() {

      isLoading = false;
    });
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

        title: const Text(

          'Buscar',

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(

              controller:
                  searchController,

              style: const TextStyle(
                color: Colors.white,
              ),

              onChanged: (
                value,
              ) {

                searchMovie(
                  value,
                );
              },

              onSubmitted: (
                value,
              ) {

                searchMovie(
                  value,
                );
              },

              decoration:
                  InputDecoration(

                hintText:
                    'Buscar películas o series...',

                hintStyle:
                    const TextStyle(
                  color: Colors.white54,
                ),

                filled: true,

                fillColor:
                    Colors.white10,

                prefixIcon:
                    const Icon(
                  Icons.search,
                  color:
                      Colors.white54,
                ),

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            if (isLoading)
              const Expanded(
                child: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              )

            else if (results.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(

                    'Busca una película o serie',

                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ),
              )

            else
              Expanded(

                child: ListView.builder(

                  itemCount:
                      results.length,

                  itemBuilder: (
                    context,
                    index,
                  ) {

                    return Padding(

                      padding:
                          const EdgeInsets.only(
                        bottom: 18,
                      ),

                      child: UserCard(
                        user: results[index],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}