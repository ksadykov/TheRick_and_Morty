import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/usecase/usecase.dart';
import 'package:rick_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_morty/feature/domain/repositories/person_repository.dart';

class SearchPerson extends UseCase<List<PersonEntity>, SearchPersonParams> {
  final PersonRepository percentRepository;

  SearchPerson(this.percentRepository);

  Future<Either<Failure, List<PersonEntity>>> call(
      SearchPersonParams params) async {
    return await percentRepository.searchPerson(params.query);
  }
}

class SearchPersonParams extends Equatable {
  final String query;

  SearchPersonParams({required this.query});

  @override
  List<Object?> get props => [query];
}
