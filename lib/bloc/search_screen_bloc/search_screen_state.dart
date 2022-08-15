part of 'search_screen_bloc.dart';

@immutable
abstract class SearchScreenState {}

class SearchScreenInitial extends SearchScreenState {}

class InitState extends SearchScreenState {}

class LoadingState extends SearchScreenState {}

class SuccessfulState extends SearchScreenState {}

class FailureState extends SearchScreenState {}
