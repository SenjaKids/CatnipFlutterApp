class BoardingSearchParams {
  final String? latitude;
  final String? longitude;
  final String? sortBy;
  final String? lowestPriceRange;
  final String? highestPriceRange;
  final List<String>? boardingCategories;
  final List<String>? boardingFacilities;
  final List<String>? boardingPetCategories;

  const BoardingSearchParams({
    this.latitude,
    this.longitude,
    this.sortBy,
    this.lowestPriceRange,
    this.highestPriceRange,
    this.boardingCategories,
    this.boardingFacilities,
    this.boardingPetCategories,
  });
}

class BoardingDetailsParams {
  final String slug;
  final String? longitude;
  final String? latitude;
  const BoardingDetailsParams({
    required this.slug,
    this.latitude,
    this.longitude,
  });
}

class HomeFilteredBoardingParams {
  final String? longitude;
  final String? latitude;
  HomeFilteredBoardingParams(
    this.longitude,
    this.latitude,
  );
}

class CheckHasAccountParams {
  final String? phoneNumber;
  CheckHasAccountParams({required this.phoneNumber});
}

class AutoCompleteParams {
  final String? googleApiKey;
  final String? query;

  AutoCompleteParams({
    required this.googleApiKey,
    required this.query,
  });
}
