import 'sub_entities.dart';

class UserDataEntity {
  final UserEntity userEntity;
  final List<PetEntity> petEntities;

  UserDataEntity({
    required this.userEntity,
    required this.petEntities,
  });
}
