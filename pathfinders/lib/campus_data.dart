import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';

final campusLocations = {
  'MacOdrum Library': [45.38206408365617, -75.69977042560764],
  'Minto CASE': [45.385279765613845, -75.69680024507261],
  'Canal Building': [45.38408812601707, -75.6985990536452],
  'Azrieli Pavilion': [45.3828752378478, -75.69899008847436],
  'Southam Hall': [45.3813454970238, -75.69969461449273],
  'Richcraft Hall': [45.38266252283785, -75.69616214118481],
  'Nicol Building': [45.38431154151964, -75.69681508335321],
  'Mackenzie Building': [45.384855301785116, -75.69801074149618],
  'Architecture Building': [45.38400947767275, -75.69743968693827],
  'Loeb Building': [45.380887411647336, -75.69865054756026],
  'Health Sciences Building': [45.383426260065264, -75.69666952887437],
  'Patterson Hall': [45.38182559302138, -75.6985031793831],
  'Herzberg Laboratories': [45.38208021485189, -75.69738688848636],
  'Dunton Tower': [45.3826556308591, -75.69937035813311],
  'Tory Building': [45.38269512493025, -75.6981735166472],
  'Teraanga Commons': [45.386978506129815, -75.69719810496152],
  'Glengarry House': [45.386700516077774, -75.6972722283149],
  'Lennox and Addington House': [45.38640305212433, -75.69710777769626],
  'Rideau House': [45.38855496984449, -75.69728962856118],
  'Frontenac House': [45.38604963991979, -75.69836080493621],
  'Lanark House': [45.385766208734026, -75.69819888293053],
  'Renfrew House': [45.386152864500716, -75.69716507319849],
  'Prescott House': [45.38571022215372, -75.6970380266733],
  'Grenville House': [45.38649752828186, -75.69847290480172],
  'Russell House': [45.38690342403793, -75.69850528920297],
  'Stormont House': [45.387746698164264, -75.69701311558298],
  'Dundas House': [45.387867414797476, -75.69762841920662],
  'Leeds House': [45.3879897199061, -75.69878468543972],
  'Carleton University Art Gallery': [45.38743687179329, -75.698318848277],
  'P18 Parking Lot': [45.38935854196861, -75.6970705614312],
  'P7 Parking Lot': [45.390676051159, -75.69607332858631],
  'P6 Parking Lot': [45.38965861560261, -75.69886432455495],
  'TAAG Park': [45.38838900950519, -75.69400629449159],
  'Ravens Field': [45.38539571529169, -75.69156346989476],
  'Carleton Athletics': [45.38634421336642, -75.69372427730944],
  'Field House': [45.38693283210334, -75.69457032871355],
  "Raven's Nest": [45.386324685626086, -75.69338665116888],
  'Alumni Hall': [45.386651076980044, -75.69293780699927],
  'Alumni Park': [45.38268421990635, -75.6946454090682],
  'Ice House': [45.385395788238334, -75.69334696606401],
  'Sport Medicine Centre': [45.38558958823419, -75.69350149097613],
  'Technology and Training Centre': [45.38452956081489, -75.69364071657793],
  'Nideyinàn': [45.38350917807664, -75.6981099726122],
  'Train Station': [45.38557986825171, -75.6959283267199],
};

List<double> vector(
  double userLatitude,
  double userLongitude,
  String buildingName,
) {
  late double buildingLatitude;
  late double buildingLongitude;

  if (campusLocations[buildingName] != null) {
    buildingLatitude = campusLocations[buildingName]![0];
    buildingLongitude = campusLocations[buildingName]![1];
  } else {
    throw Exception('Building not found');
  }

  double distance = Geolocator.distanceBetween(
    userLatitude,
    userLongitude,
    buildingLatitude,
    buildingLongitude
  );
  double bearing = Geolocator.bearingBetween(
    userLatitude,
    userLongitude,
    buildingLatitude,
    buildingLongitude
  );

  return [distance, bearing];
}