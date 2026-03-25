class ApiConstants {
  static String apikey = 'AIzaSyBTWbhCimcwXcTzYie6oFF8-gUzmGz5fac';
  static String access_token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjIwNjkxZGYwOWEwOWU3MDA1ODQ2ODYyMWI2ZTFlNiIsIm5iZiI6MTY0ODUzOTcyMi40MzEsInN1YiI6IjYyNDJiODRhZDcxZmI0MDA0N2Y4NDY3ZiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.VGSDh6aE1KWQiZEpkbrTudEipbalTUBtrFC9IrV5t30';
  static String baseUrl = 'https://maps.googleapis.com/maps/api/geocode/';

  // final headers = {
  //   'Authorization': 'Bearer $access_token',
  //   'accept': 'application/json',
  // };

  final headers = {'accept': 'application/json'};
  static const String themeModeKey = 'THEME_MODE';
  static const String favoritesKey = 'favorites';
}
