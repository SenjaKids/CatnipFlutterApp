import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class UpdatePetData {
  final AuthRepository authRepository;

  UpdatePetData(this.authRepository);

  Future<Either<Failure, bool>> call(
      {required String accessToken,
      required PostPetDataBody postPetDataBody,
      required String petId}) async {
    return await authRepository.updatePetData(
        accessToken: accessToken,
        postPetDataBody: postPetDataBody,
        petId: petId);
  }
}
