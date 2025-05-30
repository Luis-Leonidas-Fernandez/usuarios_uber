import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:usuario_inri/blocs/user/auth_bloc.dart';
import 'package:usuario_inri/service/reverse_geocoding.dart';

part 'search_bar_event.dart';
part 'search_bar_state.dart';


class SearchBarBloc extends Bloc<SearchBarEvent, SearchBarState> {
  final AuthBloc authBloc;
  
  SearchBarBloc({required this.authBloc}) : super(const SearchBarState()) {
    on<OnTextChangedEvent>(_onTextChanged);
    on<OnSuggestionSelectedEvent>(_onSuggestionSelected);
  }




  // Realiza la busqueda de la direccion escrita en el search bar del mapa
  Future<void> _onTextChanged(
  OnTextChangedEvent event,
  Emitter<SearchBarState> emit,
) async {
  emit(state.copyWith(isLoading: true));

  try {
    
    final accessToken =  authBloc.state.usuario?.tokenMapBox;

    if (accessToken == null) {
      emit(state.copyWith(isLoading: false));
      return;
    }

    final suggestions = await getSuggestionsFromMapbox(event.text, accessToken );
    emit(state.copyWith(suggestions: suggestions, isLoading: false));
  } catch (e) {
    emit(state.copyWith(isLoading: false));
    // Podés emitir un error en el estado si querés manejarlo con Snackbar o UI
  }
}


  void _onSuggestionSelected(
    OnSuggestionSelectedEvent event,
    Emitter<SearchBarState> emit,
  ) {
    final newHistory = List<Map<String, dynamic>>.from(state.history);
    newHistory.removeWhere((item) => item['name'] == event.name);
    newHistory.insert(0, {
      'name': event.name,
      'coords': event.coords,
    });

    if (newHistory.length > 5) {
      newHistory.removeLast();
    }

    emit(state.copyWith(history: newHistory, suggestions: []));
  }
}