import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class GetPetBreedsAndHabits {
  final AuthRepository authRepository;

  GetPetBreedsAndHabits(this.authRepository);

  Future<Either<Failure, PetBreedsAndHabitsEntities>> call(
      {required String accessToken, required String petCategory}) async {
    return await authRepository.getPetBreedsandHabits(
        accessToken: accessToken, petCategory: petCategory);
  }
}
