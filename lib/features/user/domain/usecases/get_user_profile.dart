import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/user_entity.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class GetUserProfile {
  final AuthRepository authRepository;

  GetUserProfile(this.authRepository);

  Future<Either<Failure, UserDataEntity>> call(
      {required String accessToken}) async {
    print('usecase');
    return await authRepository.getUserProfile(accessToken: accessToken);
  }
}
