part of 'description_screen_bloc.dart';

@immutable
abstract class DescriptionScreenEvent {}

class InitEvent extends DescriptionScreenEvent {
  final int movieID;
  final bool isFavourite;

  InitEvent({required this.movieID, required this.isFavourite});
}

class FavouriteEvent extends DescriptionScreenEvent {
  final MovieDetail movie;

  FavouriteEvent({required this.movie});
}
