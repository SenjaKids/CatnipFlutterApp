import 'package:dartz/dartz.dart';
import 'package:zladag_flutter_app/core/errors/failure.dart';
import 'package:zladag_flutter_app/core/params/body.dart';
import 'package:zladag_flutter_app/features/user/domain/repositories/auth_repository.dart';

class GetOTP {
  final AuthRepository authRepository;

  GetOTP(this.authRepository);

  Future<Either<Failure, String>> call({required GetOTPBody getOTPBody}) async {
    return await authRepository.getOTP(getOTPBody: getOTPBody);
  }
}
