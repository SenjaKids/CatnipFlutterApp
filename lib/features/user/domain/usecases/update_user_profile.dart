import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class UpdateUserProfile {
  final AuthRepository authRepository;

  UpdateUserProfile(this.authRepository);

  Future<Either<Failure, bool>> call(
      {required String accessToken,
      required UpdateUserProfileBody updateUserProfileBody}) async {
    return await authRepository.updateUserProfile(
        accessToken: accessToken, updateUserProfileBody: updateUserProfileBody);
  }
}
