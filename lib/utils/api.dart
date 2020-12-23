import 'package:http/http.dart' as http;

class Github {
  final String userName;
  static String getAllUsers = 'https://api.github.com/users';
  static String client_id = 'Your_github_client_id';
  static String client_secret = 'Your_github_client_secret';

  final String query = "?client_id=${client_id}&client_secret=${client_secret}";

  Github(this.userName);

  Future<http.Response> fetchUser() {
    return http.get(getAllUsers + userName + query);
  }

  Future<http.Response> fetchUserList() {
    return http.get(getAllUsers);
  }

  Future<http.Response> fetchUserDetails() {
    return http.get("$getAllUsers/$userName");
  }
}
