import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class GetPetDetails {
  final AuthRepository authRepository;

  GetPetDetails(this.authRepository);

  Future<Either<Failure, PetEntity>> call(
      {required String accessToken, required String petId}) async {
    return await authRepository.getPetDetails(
        accessToken: accessToken, petId: petId);
  }
}
