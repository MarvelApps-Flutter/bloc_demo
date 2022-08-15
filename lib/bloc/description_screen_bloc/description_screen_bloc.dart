import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_module/model/movie_detail_model.dart';
import 'package:meta/meta.dart';

import '../../services/api_constant.dart';
import '../../services/rest_api_services.dart';

part 'description_screen_event.dart';
part 'description_screen_state.dart';

class DescriptionScreenBloc
    extends Bloc<DescriptionScreenEvent, DescriptionScreenState> {
  MovieDetail? movieDetail;
  final _movieDetailStreamController = StreamController<MovieDetail?>();
  StreamSink<MovieDetail?> get movieDetailSink =>
      _movieDetailStreamController.sink;
  Stream<MovieDetail?> get movieDetailData =>
      _movieDetailStreamController.stream;

  DescriptionScreenBloc() : super(DescriptionScreenInitial()) {
    on<InitEvent>((event, emit) => _init(event, emit));
    on<FavouriteEvent>((((event, emit) => _isFavourite(event, emit))));
  }

  _init(InitEvent event, Emitter<DescriptionScreenState> emit) async {
    final _response = await RestApiServices().fetchApiData(
        path: APIconstant.moviePath + event.movieID.toString(),
        append: 'credits,reviews');
    final MovieDetail _movieDetail = MovieDetail.fromJson(_response.data);
    movieDetail = _movieDetail;
    movieDetail!.isFavourite = event.isFavourite;
    movieDetailSink.add(movieDetail);
  }

  _isFavourite(FavouriteEvent event, Emitter<DescriptionScreenState> emit) {
    event.movie.isFavourite = !event.movie.isFavourite;
    movieDetailSink.add(movieDetail);
  }

  dispose() {
    _movieDetailStreamController.close();
  }
}
