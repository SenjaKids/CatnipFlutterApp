import 'dart:io';

import 'package:zladag_flutter_app/features/reservation/domain/entities/reservation_entity.dart';

// import 'package:flutter/material.dart';

class GetOTPBody {
  final String phoneNumber;
  const GetOTPBody({
    required this.phoneNumber,
  });
}

class ValidateOTPBody {
  final String phoneNumber;
  final String otp;
  const ValidateOTPBody({
    required this.phoneNumber,
    required this.otp,
  });
}

class SignUpUserBody {
  final String signMethod;
  final String phoneNumber;
  final String name;
  final String? email;
  const SignUpUserBody({
    required this.signMethod,
    required this.phoneNumber,
    required this.name,
    required this.email,
  });
}

class SignInUserBody {
  final String signMethod;
  final String? phoneNumber;
  final String? email;
  const SignInUserBody({
    required this.signMethod,
    this.phoneNumber,
    this.email,
  });
}

class PostPetDataBody {
  final String petBreedId;
  final String petGender;
  final String name;
  final int age;
  final double bodyMass;
  final bool hasBeenSterilized;
  final bool hasBeenVaccinatedRoutinely;
  final bool hasBeenFleaFreeRegularly;
  final String? historyOfIllness;
  final List<String> boardingFacilities;
  final List<String> petHabitIds;
  final File? image;

  PostPetDataBody({
    required this.petBreedId,
    required this.petGender,
    required this.name,
    required this.age,
    required this.bodyMass,
    required this.hasBeenSterilized,
    required this.hasBeenVaccinatedRoutinely,
    required this.hasBeenFleaFreeRegularly,
    required this.historyOfIllness,
    required this.boardingFacilities,
    required this.petHabitIds,
    required this.image,
  });
}

class UpdateUserProfileBody {
  final String name;
  final File? image;

  UpdateUserProfileBody({
    required this.image,
    required this.name,
  });
}

class PostOrderBody {
  final String slug;
  final String checkInDate;
  final String checkOutDate;
  final List<OrderEntity> orders;

  PostOrderBody(
      {required this.slug,
      required this.checkInDate,
      required this.checkOutDate,
      required this.orders});
}
