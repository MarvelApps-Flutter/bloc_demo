part of 'home_screen_bloc.dart';

@immutable
abstract class HomeScreenEvent {}

class InitEvent extends HomeScreenEvent {}

class GenreSelectionEvent extends HomeScreenEvent {
  final int index;
  GenreSelectionEvent({required this.index});
}

class FavouriteEvent extends HomeScreenEvent {
  final Results movie;

  FavouriteEvent({required this.movie});
}
