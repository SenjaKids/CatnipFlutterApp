import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class ValidateOTP {
  final AuthRepository authRepository;

  ValidateOTP(this.authRepository);

  Future<Either<Failure, bool>> call(
      {required ValidateOTPBody validateOTPBody}) async {
    return await authRepository.validateOTP(validateOTPBody: validateOTPBody);
  }
}
