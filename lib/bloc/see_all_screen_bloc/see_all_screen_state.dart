part of 'see_all_screen_bloc.dart';

@immutable
abstract class SeeAllScreenState {}

class SeeAllScreenInitial extends SeeAllScreenState {}

class InitState extends SeeAllScreenState {}

class LoadingState extends SeeAllScreenState {}

class SuccessfulState extends SeeAllScreenState {}

class FailureState extends SeeAllScreenState {}
