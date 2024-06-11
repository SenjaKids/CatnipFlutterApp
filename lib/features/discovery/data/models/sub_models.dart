import 'dart:convert';

import 'package:zladag_flutter_app/core/constants/constants.dart';
import 'package:zladag_flutter_app/features/discovery/domain/entities/sub_entities.dart';

class CagesModel extends CagesEntity {
  CagesModel(super.cage);

  static List<CagesModel>? fromJson(List<dynamic>? jsonList) {
    List<CagesModel>? returnedList = [];
    if (jsonList != null) {
      for (Map<String, dynamic> json in jsonList) {
        returnedList.add(
          CagesModel(
            CageModel.fromJson(json),
          ),
        );
      }
      return returnedList;
    }
    return null;
  }

  dynamic toJson() {
    return {
      cage,
    };
  }
}

class CageModel extends CageEntity {
  CageModel(
    super.id,
    super.name,
    super.length,
    super.width,
    super.height,
    super.price,
  );

  factory CageModel.fromJson(Map<String, dynamic> json) {
    return CageModel(
      json['id'],
      json[baCageName],
      json[baCageLength],
      json[baCageWidth],
      json[baCageHeight],
      json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      baCageName: name,
      baCageLength: length,
      baCageWidth: width,
      baCageHeight: height,
      'price': price,
    };
  }
}

class BoardingPolicyModel extends BoardingPolicyEntity {
  BoardingPolicyModel(
    super.startCheckInTime,
    super.endCheckInTime,
    super.startCheckOutTime,
    super.endCheckOutTime,
    super.vaccinated,
    super.fleaFree,
    super.minAge,
    super.maxAge,
  );

  factory BoardingPolicyModel.fromJson(Map<String, dynamic> json) {
    return BoardingPolicyModel(
      json[baStartCheckIn],
      json[baEndCheckIn],
      json[baStartCheckOut],
      json[baEndCheckOut],
      json[baVacinated],
      json[baFleaFree],
      json[baMinAge],
      json[baMaxAge],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      baStartCheckIn: startCheckInTime,
      baEndCheckIn: endCheckInTime,
      baStartCheckOut: startCheckOutTime,
      baEndCheckOut: endCheckOutTime,
      baVacinated: vaccinated,
      baFleaFree: fleaFree,
      baMinAge: minAge,
      baMaxAge: maxAge,
    };
  }
}

class BoardingLocationModel extends BoardingLocationEntity {
  BoardingLocationModel(
    super.address,
    super.mapLink,
  );

  factory BoardingLocationModel.fromJson(Map<String, dynamic> json) {
    return BoardingLocationModel(
      json[baAddress],
      json[baMapLink],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      baAddress: address,
      baMapLink: mapLink,
    };
  }
}

class PlaceAutocompleteResponse {
  final String? status;
  final List<AutocompletePrediction>? predictions;

  PlaceAutocompleteResponse({this.status, this.predictions});

  factory PlaceAutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return PlaceAutocompleteResponse(
      status: json['status'] as String?,
      predictions: json['predictions'] != null
          ? json['predictions']
              .map<AutocompletePrediction>(
                  (json) => AutocompletePrediction.fromJson(json))
              .toList()
          : null,
    );
  }

  static PlaceAutocompleteResponse parseAutocompleteResult(
      String responseBody) {
    final parsed = json.decode(responseBody).cast<String, dynamic>();

    return PlaceAutocompleteResponse.fromJson(parsed);
  }

  // static PlaceAutocompleteResponse parseAutocompleteResult(
  //     String responseBody) {
  //   final parsed = json.decode(responseBody).cast<String, dynamic>();

  //   return PlaceAutocompleteResponse.fromJson(parsed);
  // }
}

class AutocompletePrediction {
  /// [description] contains the human-readable name for the returned result. For establishment results, this is usually
  /// the business name.
  final String? description;

  /// [structuredFormatting] provides pre-formatted text that can be shown in your autocomplete results
  final StructuredFormatting? structuredFormatting;

  /// [placeId] is a textual identifier that uniquely identifies a place. To retrieve information about the place,
  /// pass this identifier in the placeId field of a Places API request. For more information about place IDs.
  final String? placeId;

  /// [reference] contains reference.
  final String? reference;

  AutocompletePrediction({
    this.description,
    this.structuredFormatting,
    this.placeId,
    this.reference,
  });

  factory AutocompletePrediction.fromJson(Map<String, dynamic> json) {
    return AutocompletePrediction(
      description: json['description'] as String?,
      placeId: json['place_id'] as String?,
      reference: json['reference'] as String?,
      structuredFormatting: json['structured_formatting'] != null
          ? StructuredFormatting.fromJson(json['structured_formatting'])
          : null,
    );
  }
}

class StructuredFormatting {
  /// [mainText] contains the main text of a prediction, usually the name of the place.
  final String? mainText;

  /// [secondaryText] contains the secondary text of a prediction, usually the location of the place.
  final String? secondaryText;

  StructuredFormatting({this.mainText, this.secondaryText});

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) {
    return StructuredFormatting(
      mainText: json['main_text'] as String?,
      secondaryText: json['secondary_text'] as String?,
    );
  }
}

class BoardingServiceModel extends BoardingServiceEntity {
  BoardingServiceModel(super.id, super.name, super.category, super.price);

  factory BoardingServiceModel.fromJson(Map<String, dynamic> json) {
    return BoardingServiceModel(
      json['id'],
      json['name'],
      json['category'],
      json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
    };
  }
}
