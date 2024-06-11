class CagesEntity {
  final CageEntity? cage;

  CagesEntity(
    this.cage,
  );
}

class CageEntity {
  String? id;
  final String? name;
  final int? length;
  final int? width;
  final int? height;
  final int? price;

  CageEntity(
    this.id,
    this.name,
    this.length,
    this.width,
    this.height,
    this.price,
  );
}

class BoardingPolicyEntity {
  final String? startCheckInTime;
  final String? endCheckInTime;
  final String? startCheckOutTime;
  final String? endCheckOutTime;
  final bool? vaccinated;
  final bool? fleaFree;
  final int? minAge;
  final int? maxAge;

  BoardingPolicyEntity(
    this.startCheckInTime,
    this.endCheckInTime,
    this.startCheckOutTime,
    this.endCheckOutTime,
    this.vaccinated,
    this.fleaFree,
    this.minAge,
    this.maxAge,
  );
}

class BoardingLocationEntity {
  final String? address;
  final String? mapLink; // google map embed link

  BoardingLocationEntity(
    this.address,
    this.mapLink,
  );
}

class BoardingServiceEntity {
  final String? id;
  final String? name;
  final String? category;
  final int? price;

  BoardingServiceEntity(
    this.id,
    this.name,
    this.category,
    this.price,
  );
}
