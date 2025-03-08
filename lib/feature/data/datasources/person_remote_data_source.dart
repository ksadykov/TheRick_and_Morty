import 'dart:convert';

import 'package:rick_morty/core/error/exception.dart';
import 'package:rick_morty/feature/data/models/person_model.dart';
import 'package:rick_morty/feature/domain/usecases/search_person.dart';
import 'package:http/http.dart' as http;

abstract class PersonRemoteDataSource {
  ///Call the https://rickandmortyapi.com/api/character/?page=1 endpoint.
  ///
  ///Thows a [ServerException] for all error code.
  Future<List<PersonModel>> getAllPerson(int page);

  ///Call the https://rickandmortyapi.com/api/character/?name=rick endpoint.
  ///
  ///Thows a [ServerException] for all error code.
  Future<List<PersonModel>> SearchPerson(String query);
}

class PersonRemoteDataSourceImpl implements PersonRemoteDataSource {
  final http.Client client;

  PersonRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PersonModel>> getAllPerson(int page) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?page=$page');

  @override
  Future<List<PersonModel>> SearchPerson(String query) => _getPersonFromUrl(
      'https://rickandmortyapi.com/api/character/?name=$query');

  Future<List<PersonModel>> _getPersonFromUrl(String url) async {
    print(url);
    final response = await client
        .get(Uri.parse(url), headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final persons = json.decode(response.body);
      return (persons['results'] as List)
          .map((person) => PersonModel.fromJson(person))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
