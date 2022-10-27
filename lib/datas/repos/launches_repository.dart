import 'package:http/http.dart' as http;
import 'package:space_x_last_launch/datas/model/launches_model.dart';

//Service to get launches with http request
class LaunchesRepository {
  final String _baseUrl = "https://api.spacexdata.com/v4/launches/";
// Function for getting launches as a list..
  Future<List<Launches>> getLaunches() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return launchesFromJson(response.body);
    } else {
      throw Exception("Failed to load");
    }
  }
}
