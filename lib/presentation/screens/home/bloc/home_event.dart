part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class EventHomeSelectPhoto extends HomeEvent{
  final ImageSource source;
  EventHomeSelectPhoto({required this.source});
}
