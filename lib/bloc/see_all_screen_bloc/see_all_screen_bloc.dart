import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../model/popular_movies_model.dart';
import '../../services/api_constant.dart';
import '../../services/rest_api_services.dart';

part 'see_all_screen_event.dart';
part 'see_all_screen_state.dart';

class SeeAllScreenBloc extends Bloc<SeeAllScreenEvent, SeeAllScreenState> {
  Movies? data;
  final _seeAllStreamController = StreamController<Movies?>();
  StreamSink<Movies?> get seeAllSink => _seeAllStreamController.sink;
  Stream<Movies?> get seeAllData => _seeAllStreamController.stream;

  SeeAllScreenBloc() : super(SeeAllScreenInitial()) {
    on<InitEvent>((event, emit) => _init(emit));
  }

  Future<void> _init(Emitter<SeeAllScreenState> emit) async {
    final _response = await RestApiServices()
        .fetchApiData(path: APIconstant.popularMoviePath);
    data = Movies.fromJson(_response.data);
    seeAllSink.add(data);
  }

  dispose() {
    _seeAllStreamController.close();
  }
}
