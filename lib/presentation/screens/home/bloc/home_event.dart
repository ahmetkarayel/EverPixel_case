part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class EventHomeSelectPhoto extends HomeEvent{
  final ImageSource source;
  EventHomeSelectPhoto({required this.source});
}

class EventHomeAdjustColor extends HomeEvent{
  final double value;
  final EnumTuneProperties type;
  EventHomeAdjustColor({required this.value, required this.type});
}
class EventHomeSetDefaultValue extends HomeEvent{
    final EnumTuneProperties type;
  EventHomeSetDefaultValue(this.type);
}

class EventHomeApproveChanges extends HomeEvent{
  final EnumTuneProperties type;
  EventHomeApproveChanges(this.type);
}

class EventHomeAddFilter extends HomeEvent{
  final EnumFilters type;
  EventHomeAddFilter(this.type);
}

class EventHomeApproveFilter extends HomeEvent{}

class EventHomeRemoveFilter extends HomeEvent{}

class EventHomeUndo extends HomeEvent{}
class EventHomeRedo extends HomeEvent{}
