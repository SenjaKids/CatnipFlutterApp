import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class SignInUser {
  final AuthRepository authRepository;

  SignInUser(this.authRepository);

  Future<Either<Failure, String>> call(
      {required SignInUserBody signInUserBody}) async {
    return await authRepository.signInUser(signInUserBody: signInUserBody);
  }
}
