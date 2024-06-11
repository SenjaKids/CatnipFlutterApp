import 'package:zladag_flutter_app/core/constants/constants.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

class PetModel extends PetEntity {
  PetModel({
    super.petCategory,
    super.petGender,
    super.hasBeenSterilized,
    super.hasBeenVaccinatedRoutinely,
    super.hasBeenFleaFreeRegularly,
    super.bodyMass,
    super.boardingFacilities,
    super.petHabits,
    super.historyOfIllness,
    super.id,
    super.name,
    super.age,
    super.image,
    super.petBreed,
  });

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json[aaPetId],
      age: json[aaPetAge],
      image: json[aaPetImage],
      name: json[aaPetName],
      petBreed: json[aaPetBreed],
      petCategory: json['petCategory'],
      petGender: json['petGender'],
      hasBeenSterilized: json['hasBeenSterilized'],
      hasBeenVaccinatedRoutinely: json['hasBeenVaccinatedRoutinely'],
      hasBeenFleaFreeRegularly: json['hasBeenFleaFreeRegularly'],
      bodyMass: json['bodyMass'],
      boardingFacilities: json['boardingFacilities'],
      petHabits: json['petHabits'],
      historyOfIllness: json['historyOfIllness'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      aaPetId: id,
      aaPetName: name,
      aaPetBreed: petBreed,
      aaPetImage: image,
      aaPetAge: age,
      'petCategory': petCategory,
      'petGender': petGender,
      'hasBeenSterilized': hasBeenSterilized,
      'hasBeenVaccinatedRoutinely': hasBeenVaccinatedRoutinely,
      'hasBeenFleaFreeRegularly': hasBeenFleaFreeRegularly,
      'bodyMass': bodyMass,
      'boardingFacilities': boardingFacilities,
      'petHabits': petHabits,
      'historyOfIllness': historyOfIllness,
    };
  }
}

class PetModels extends PetEntities {
  PetModels({super.petEntities});

  // factory PetModels.fromJson(Map<String, dynamic> json) {
  //   return PetModels(
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {'pets': petEntities};
  }
}

class PetHabitModel extends PetHabitEntity {
  PetHabitModel({required super.id, required super.name});

  factory PetHabitModel.fromJson(Map<String, dynamic> json) {
    return PetHabitModel(
      id: json[aaPetHabitId],
      name: json[aaPetHabitName],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      aaPetHabitId: id,
      aaPetHabitName: name,
    };
  }

  // List<String> getHabitsNameList(){
  //   List<String> habits = [];
  //   for Pet
  //   return
  // }
}

class PetBreedModel extends PetBreedEntity {
  PetBreedModel({required super.id, required super.name});

  factory PetBreedModel.fromJson(Map<String, dynamic> json) {
    return PetBreedModel(
      id: json[aaPetBreedId],
      name: json[aaPetBreedName],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      aaPetBreedId: id,
      aaPetBreedName: name,
    };
  }
}
