import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/user_view_model.dart';
import '../widgets/user_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserViewModel>(context, listen: false).fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserViewModel>(context);
    final user = viewModel.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF090B13),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F1A),
        elevation: 0,
        foregroundColor: Colors.white,

        iconTheme: const IconThemeData(
          color: Colors.white,
          size: 28,
        ),

        title: Row(
          children: const [
            Icon(
              Icons.movie_creation_rounded,
              color: Colors.redAccent,
            ),
            SizedBox(width: 10),
            Text(
              "Movie Explorer",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, "/search");
            },
          )
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF151528),
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.cyanAccent,
                child: Icon(Icons.person, size: 40, color: Color(0xFF0F0F1E)),
              ),
              accountName: Text(
                user?['name'] ?? 'Usuario de Cine',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(
                user?['email'] ?? 'sin_correo@movie.com',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
            const Spacer(),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              onTap: () => viewModel.logoutUser(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyanAccent))
          : viewModel.errorMessage.isNotEmpty
              ? Center(
                  child: Text(
                    viewModel.errorMessage,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                )
              : AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFeaturedMovie(viewModel),
                      const SizedBox(height: 30),
                      _buildMovieSection('En Cartelera Ahora', viewModel.nowPlaying),
                      const SizedBox(height: 24),
                      _buildMovieSection('Acción Trepidante', viewModel.actionMovies),
                      const SizedBox(height: 24),
                      _buildMovieSection('Series Destacadas', viewModel.series),
                      const SizedBox(height: 24),
                      _buildMovieSection('Películas Familiares', viewModel.familyMovies),
                      const SizedBox(height: 24),
                      _buildMovieSection('Sección Infantil', viewModel.kidsMovies),
                    ],
                  ),
                  ),
                ),
    );
  }

  Widget _buildMovieSection(String title, List<dynamic> movies) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.5),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 340,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: UserCard(userEntity: movie), 
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedMovie(UserViewModel viewModel) {

  if (viewModel.nowPlaying.isEmpty) {
    return const SizedBox();
  }

  final movie = viewModel.nowPlaying.first;

  return Container(
    height: 240,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(22),
      image: DecorationImage(
        image: NetworkImage(
          movie.backdrop.isNotEmpty
              ? 'https://image.tmdb.org/t/p/w780${movie.backdrop}'
              : 'https://image.tmdb.org/t/p/w500${movie.image}',
        ),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withOpacity(.9),
            Colors.transparent,
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Text(
            movie.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: movie,
              );
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text("Ver detalles"),
          )
        ],
      ),
    ),
  );
}
}
