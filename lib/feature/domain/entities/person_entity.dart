import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class PersonEntity extends Equatable {
  final int? id;
  final String? name;
  final String? status;
  final String? species;
  final String? type;
  final String? generel;
  final LocationEntity? origin;
  final LocationEntity? location;
  final String? image;
  final List<String>? episode;
  final DateTime? created;

  PersonEntity(
      {@required this.id,
      @required this.name,
      @required this.status,
      @required this.species,
      @required this.type,
      @required this.generel,
      @required this.origin,
      @required this.location,
      @required this.image,
      @required this.episode,
      @required this.created});

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        name,
        status,
        species,
        type,
        generel,
        origin,
        location,
        image,
        episode,
        created
      ];
}

class LocationEntity {
  final String? name;
  final String? url;

  const LocationEntity({this.name, this.url});
}
