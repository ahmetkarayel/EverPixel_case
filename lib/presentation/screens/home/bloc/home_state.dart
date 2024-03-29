part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class StateHomeLoadingAlert extends HomeState{}

class StateHomeHasPhoto extends HomeState{
  final ui.Image? image;
  StateHomeHasPhoto({required this.image});
}

class StateHomeEditedImage extends HomeState{
  final ui.Image? image;
  final EnumTuneProperties? type;
  final bool reset;
  StateHomeEditedImage(this.image, {this.reset=false, this.type});
}

