import 'package:geolocator/geolocator.dart';
import 'package:login/dash_board_user/assistance/request.dart';

class AssistanceMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAddress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAdk4UX0CwDxSmH2p92_B9DtR5jQdRHqjQ";

    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed, Status Code: ${response.statusCode}") {
      placeAddress = response['results'][0]["formatted_address"];
    }

    return placeAddress;
  }
}
