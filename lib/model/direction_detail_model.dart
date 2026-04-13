class DirectionDetailModel
// legs,distance, duraation,polyline
{
  String? distanceText;
  String? durationText;
  int? distanceValue;
  int? durationValue;
  String? encodedPoints;

  DirectionDetailModel(
    this.distanceText,
    this.durationText,
    this.distanceValue,
    this.durationValue,
    this.encodedPoints,
  );

  DirectionDetailModel.fromJson(Map json) {
    distanceText = json['legs'][0]['distance']['text'];
    durationText = json['legs'][0]['duration']['text'];
    distanceValue = json['legs'][0]['distance']['value'];
    durationValue = json['legs'][0]['duration']['value'];
    encodedPoints = json['overview_polyline']['points'];
  }
}
