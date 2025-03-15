import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/feature/domain/usecases/search_person.dart';
import 'package:rick_morty/feature/presentation/bloc/search_bloc/search_event.dart';
import 'package:rick_morty/feature/presentation/bloc/search_bloc/search_state.dart';

class PersonSearchBloc extends Bloc<PersonSearchEvent, PersonSearchState> {
  final SearchPerson searchPersons;

  PersonSearchBloc({required this.searchPersons}) : super(PersonEmpty());

  @override
  Stream<PersonSearchState> mapEventToState(PersonSearchEvent event) async* {
    if (event is SearchPersons) {
      yield* _mapFetchPersonsToSate(event.personQuery);
    }
  }

  Stream<PersonSearchState> _mapFetchPersonsToSate(String personQuery) async* {
    yield PersonSearchLoading();

    final failureOrPerson =
        await searchPersons(SearchPersonParams(query: personQuery));

    yield failureOrPerson.fold(
        (failure) => PersonSearchError(message: _mapFailureToMessage(failure)),
        (person) => PersonSearchLoaded(persons: person));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server Failure';
      case CacheFailure:
        return 'Cache Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
