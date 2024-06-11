import 'dart:io';

class UserEntity {
  final String? id;
  final String? name;
  final String? image;

  UserEntity({
    this.id,
    this.name,
    this.image,
  });
}

class PetEntity {
  String? id;
  final String? name;
  final String? petCategory;
  final String? petBreed;
  final String? petGender;
  final bool? hasBeenSterilized;
  final bool? hasBeenVaccinatedRoutinely;
  final bool? hasBeenFleaFreeRegularly;
  final int? age;
  final double? bodyMass;
  final List<dynamic>? boardingFacilities;
  final List<dynamic>? petHabits;
  final String? historyOfIllness;
  final File? image;

  PetEntity({
    this.petCategory,
    this.petGender,
    this.hasBeenSterilized,
    this.hasBeenVaccinatedRoutinely,
    this.hasBeenFleaFreeRegularly,
    this.bodyMass,
    this.boardingFacilities,
    this.petHabits,
    this.historyOfIllness,
    this.id,
    this.name,
    this.petBreed,
    this.age,
    this.image,
  });
}

class PetEntities {
  List<PetEntity>? petEntities;

  PetEntities({this.petEntities});
}

class PetBreedsAndHabitsEntities {
  final List<PetBreedEntity> petBreedEntities;
  final List<PetHabitEntity> petHabitEntities;

  PetBreedsAndHabitsEntities({
    required this.petBreedEntities,
    required this.petHabitEntities,
  });
}

class PetBreedEntity {
  final String id;
  final String name;

  PetBreedEntity({
    required this.id,
    required this.name,
  });
}

class PetHabitEntity {
  final String id;
  final String name;

  PetHabitEntity({
    required this.id,
    required this.name,
  });
}
