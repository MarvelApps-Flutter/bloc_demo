import 'dart:math';
import 'package:flutter/material.dart';
import '../bloc/home_screen_bloc/home_screen_bloc.dart';
import '../model/genre_model.dart';
import '../model/popular_movies_model.dart';
import '../widget/common_component.dart';
import '../widget/styles.dart';

import 'description_screen.dart';
import 'search_screen.dart';
import 'see_all_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeScreenBloc _bloc;

  @override
  void initState() {
    _bloc = HomeScreenBloc()..add(InitEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F2340),
      body: _body(context),
    );
  }

  SingleChildScrollView _body(
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Container(
        color: const Color(0xFF1F2340),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 35),
              child: _customAppbar(context),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  _headerTextWidget(context, 'Popular Movies'),
                  const Spacer(),
                  Baseline(
                    baseline: 18,
                    baselineType: TextBaseline.alphabetic,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const SeeAllScreen()));
                      },
                      child: Text('See all', style: Styles.style1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: _bloc.popularMovieData,
                builder: (context, AsyncSnapshot<Movies?> snapshot) {
                  return snapshot.hasData
                      ? _popularMoviesDataContainer(context, snapshot.data!)
                      : _popularMoviesLoaderWidget(context);
                }),
            Padding(
              padding: const EdgeInsets.only(left: 15, bottom: 10),
              child: _headerTextWidget(context, 'Genres'),
            ),
            _genresLableContainer(),
            StreamBuilder(
                stream: _bloc.genreBasedMovieData,
                builder: (context, AsyncSnapshot<Movies?> snapshot) {
                  return snapshot.hasData
                      ? _genreBasedMovieDataContainer(context, snapshot.data!)
                      : _genreBasedMovieLoaderWidget(context);
                }),
          ],
        ),
      ),
    );
  }

  SizedBox _genreBasedMovieLoaderWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.42,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            SizedBox(
              height: 60,
            ),
            Center(child: CircularProgressIndicator()),
          ],
        ));
  }

  SizedBox _popularMoviesLoaderWidget(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.42,
        width: double.infinity,
        child: const Center(child: CircularProgressIndicator()));
  }

  LimitedBox _genreBasedMovieDataContainer(BuildContext context, Movies data) {
    return LimitedBox(
      maxHeight: MediaQuery.of(context).size.height * 5,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(top: 15, bottom: 30, left: 10, right: 10),
          shrinkWrap: true,
          itemCount: min(data.results!.length, 10),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () async {
                  bool isfav =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => DescriptionScreen(
                                movieID: data.results![index].id,
                                isfavourite: data.results![index].favourite,
                              )));
                  if (isfav != data.results![index].favourite) {
                    _bloc.add(FavouriteEvent(movie: data.results![index]));
                  }
                },
                child: SizedBox(
                  height: 220,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    color: const Color(0xFF12172E),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.38,
                          height: 220,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(25),
                                bottomLeft: Radius.circular(25)),
                            child: Image.network(
                              data.results![index].fullImageUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width -
                                MediaQuery.of(context).size.width * 0.38 -
                                80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _bloc.add(FavouriteEvent(
                                            movie: data.results![index]));
                                      },
                                      child: Icon(
                                        Icons.favorite,
                                        color: data.results![index].favourite
                                            ? Colors.red
                                            : Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width -
                                      MediaQuery.of(context).size.width * 0.38 -
                                      90,
                                  child: Text(
                                      data.results![index].originalTitle
                                          .toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.style2),
                                ),
                                _ratingStarWidget(data, index, context),
                                Text(data.results![index].genre,
                                    maxLines: null, style: Styles.style3),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Padding _ratingStarWidget(Movies data, int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: 110,
        child: Row(
          children: List.generate(6, (index1) {
            double rating = (5 * data.results![index].voteAverage! * 10) / 100;
            return CommonComponent.getRating(context, index1, rating);
          }),
        ),
      ),
    );
  }

  Widget _genresLableContainer() {
    return StreamBuilder(
      stream: _bloc.genreBooleanData,
      builder: (context, AsyncSnapshot<List<bool>> snapshot) {
        return snapshot.hasData
            ? SizedBox(
                height: 30,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  scrollDirection: Axis.horizontal,
                  itemCount: Genres().genres.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () {
                          // _bloc.setSelectedGenre(index);
                          _bloc.add(GenreSelectionEvent(index: index));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            color: snapshot.data!.isNotEmpty
                                ? snapshot.data![index]
                                    ? const Color(0xFF127ADA)
                                    : const Color(0xFF12172E)
                                : index == 0
                                    ? const Color(0xFF127ADA)
                                    : const Color(0xFF12172E),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 8),
                          child: Text(Genres().genres[index].name,
                              maxLines: 1, style: Styles.style4),
                        ),
                      ),
                    );
                  },
                ),
              )
            : Container();
      },
    );
  }

  SizedBox _popularMoviesDataContainer(BuildContext context, Movies data) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: min(data.results!.length, 10),
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      bool isfav = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                DescriptionScreen(
                                  movieID: data.results![index].id,
                                  isfavourite: data.results![index].favourite,
                                )),
                      );
                      if (isfav != data.results![index].favourite) {
                        _bloc.add(FavouriteEvent(movie: data.results![index]));
                      }
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 200,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          child: Image.network(
                            data.results![index].fullImageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4 - 10,
                    child: Text(data.results![index].originalTitle.toString(),
                        maxLines: null, style: Styles.style5),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(data.results![index].genre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.style6),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Text _headerTextWidget(BuildContext context, String text) {
    return Text(text,
        maxLines: 1, overflow: TextOverflow.ellipsis, style: Styles.style7);
  }

  Row _customAppbar(BuildContext context) {
    return Row(
      children: [
        CommonComponent.iconCard(context, Icons.view_headline_rounded),
        const Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => const SearchScreen()));
          },
          child: CommonComponent.iconCard(context, Icons.search),
        ),
        CommonComponent.iconCard(context, Icons.notifications)
      ],
    );
  }
}
