import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class PostPetData {
  final AuthRepository authRepository;

  PostPetData(this.authRepository);

  Future<Either<Failure, bool>> call(
      {required String accessToken,
      required PostPetDataBody postPetDataBody}) async {
    return await authRepository.postPetData(
        accessToken: accessToken, postPetDataBody: postPetDataBody);
  }
}
