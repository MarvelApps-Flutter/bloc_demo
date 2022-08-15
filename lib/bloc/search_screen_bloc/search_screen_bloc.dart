import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/popular_movies_model.dart';
import '../../services/api_constant.dart';
import '../../services/rest_api_services.dart';

part 'search_screen_event.dart';
part 'search_screen_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  Movies? searchMovies;
  String seachText = "";
  final _searchMoviesStreamController = StreamController<Movies?>();
  StreamSink<Movies?> get searchMoviesSink =>
      _searchMoviesStreamController.sink;
  Stream<Movies?> get searchMoviesData => _searchMoviesStreamController.stream;
  SearchScreenBloc() : super(SearchScreenInitial()) {
    on<InitEvent>((event, emit) => _init(emit));
  }

  Future<void> _init(Emitter<SearchScreenState> emit) async {
    searchMoviesSink.add(searchMovies = null);
    final _response = await RestApiServices().fetchApiData(
        path: APIconstant.searchMoviePath,
        text: seachText == '' ? seachText = 'a' : seachText);
    searchMovies = Movies.fromJson(_response.data);
    searchMoviesSink.add(searchMovies);
  }

  dispose() {
    _searchMoviesStreamController.close();
  }
}
