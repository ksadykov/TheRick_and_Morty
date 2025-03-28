import 'package:dartz/dartz.dart';
import 'package:rick_morty/core/error/exception.dart';
import 'package:rick_morty/core/error/failure.dart';
import 'package:rick_morty/core/platform/network_info.dart';
import 'package:rick_morty/feature/data/datasources/person_local_data_source.dart';
import 'package:rick_morty/feature/data/datasources/person_remote_data_source.dart';
import 'package:rick_morty/feature/data/models/person_model.dart';
import 'package:rick_morty/feature/domain/entities/person_entity.dart';
import 'package:rick_morty/feature/domain/repositories/person_repository.dart';

class PersonRepositoryImpl implements PersonRepository {
  final PersonRemoteDataSource remoteDataSource;
  final PersonLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PersonRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<PersonEntity>>> getAllPersons(int page) async {
    return await _getPersons(() {
      return remoteDataSource.getAllPerson(page);
    });
  }

  @override
  Future<Either<Failure, List<PersonEntity>>> searchPerson(String query) async {
    return await _getPersons(() {
      return remoteDataSource.getAllPerson(query as int);
    });
  }

  Future<Either<Failure, List<PersonModel>>> _getPersons(
      Future<List<PersonModel>> Function() getPersons) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePerson = await getPersons();
        localDataSource.personToCache(remotePerson);
        return Right(remotePerson);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localtionPerson = await localDataSource.getLastPersonFromCach();
        return Right(localtionPerson);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
