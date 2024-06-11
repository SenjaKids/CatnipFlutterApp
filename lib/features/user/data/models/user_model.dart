import 'package:zladag_flutter_app/core/constants/constants.dart';
import 'package:zladag_flutter_app/features/user/domain/entities/sub_entities.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.name,
    super.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json[aaUserId],
      image: json[aaUserImage],
      name: json[aaUserName],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      aaUserId: id,
      aaUserName: name,
      aaUserImage: image,
    };
  }
}
