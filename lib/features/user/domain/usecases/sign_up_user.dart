import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class SignUpUser {
  final AuthRepository authRepository;

  SignUpUser(this.authRepository);

  Future<Either<Failure, bool>> call(
      {required SignUpUserBody signUpUserBody}) async {
    return await authRepository.signUpUser(signUpUserBody: signUpUserBody);
  }
}
