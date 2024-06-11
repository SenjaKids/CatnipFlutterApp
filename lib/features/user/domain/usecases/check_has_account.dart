import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/params.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class CheckHasAccount {
  final AuthRepository authRepository;

  CheckHasAccount(this.authRepository);

  Future<Either<Failure, bool>> call(
      {required CheckHasAccountParams params}) async {
    return await authRepository.checkHasAccount(params: params);
  }
}
