part of 'search_bar_bloc.dart';

class SearchBarState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> suggestions;
  final List<Map<String, dynamic>> history;

  const SearchBarState({
    this.isLoading = false,
    this.suggestions = const [],
    this.history = const [],
  });

  SearchBarState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? suggestions,
    List<Map<String, dynamic>>? history,
  }) {
    return SearchBarState(
      isLoading: isLoading ?? this.isLoading,
      suggestions: suggestions ?? this.suggestions,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [isLoading, suggestions, history];
}

