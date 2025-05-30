part of 'search_bar_bloc.dart';

abstract class SearchBarEvent extends Equatable {
  const SearchBarEvent();

  @override
  List<Object?> get props => [];
}

class OnTextChangedEvent extends SearchBarEvent {
  final String text;

  const OnTextChangedEvent(this.text);

  @override
  List<Object?> get props => [text];
}

class OnSuggestionSelectedEvent extends SearchBarEvent {
  final String name;
  final LatLng coords;

  const OnSuggestionSelectedEvent({required this.name, required this.coords});

  @override
  List<Object?> get props => [name, coords];
}
