part of 'description_screen_bloc.dart';

@immutable
abstract class DescriptionScreenState {}

class DescriptionScreenInitial extends DescriptionScreenState {}

class InitState extends DescriptionScreenState {}

class LoadingState extends DescriptionScreenState {}

class SuccessfulState extends DescriptionScreenState {}

class FailureState extends DescriptionScreenState {}
