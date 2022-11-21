import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

/// initialize the global API accessor
PoliisiautoApi api =
    PoliisiautoApi(host: 'http://192.168.56.56', version: 'v1');

class PoliisiautoApi {
  final String host;
  final String version;
  final storage = const FlutterSecureStorage();

  PoliisiautoApi({required this.host, required this.version}) {
    print('i was constructed');
  }

  //////////////////////////////////////////////////////////////////////////////
  /// API endpoints
  //////////////////////////////////////////////////////////////////////////////

  Future<String?> sendLogin(Credentials credentials) async {
    var request = await buildRequest('POST', 'login');

    request.fields.addAll({
      'email': credentials.email,
      'password': credentials.password,
      'device_name': credentials.deviceName
    });

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      print('Error: ${response.stream.bytesToString()}');
      return null;
      //throw Exception('Failed to login (${response.statusCode})');
    }
  }

  Future<bool> sendLogout() async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.56.56/api/v1/logout'));

    request.headers.addAll({'Authorization': 'Bearer $apiKey'});

    http.StreamedResponse response = await request.send();

    return response.statusCode == 200;
  }

  Future<List<Report>> fetchReports() async {
    var request = await buildAuthenticatedRequest('GET', 'reports');
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      //return Album.fromJson(jsonDecode(response.body));
      //List<Report> reports;
      //return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
      final List<dynamic> reportsJson =
          jsonDecode(await response.stream.bytesToString());

      List<Report> reports = [];
      for (var reportJson in reportsJson) {
        reports.add(Report.fromJson(reportJson));
      }

      return reports;
    } else {
      //print(response.reasonPhrase);
      throw Exception('Failed to load reports');
    }
  }

  Future<Report> fetchReport(int reportId) async {
    var request = await buildAuthenticatedRequest('GET', 'reports/$reportId');
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      //print(await response.stream.bytesToString());
      //return Album.fromJson(jsonDecode(response.body));
      //List<Report> reports;
      return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
    } else {
      //print(response.reasonPhrase);
      throw Exception('Failed to load report');
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Bearer Token
  //////////////////////////////////////////////////////////////////////////////

  Future<void> setTokenAsync(String token) async {
    storage.write(key: 'bearer_token', value: token);
  }

  Future<String?> getTokenAsync() async {
    return storage.read(key: 'bearer_token');
  }

  /// Synchronously set token.
  void setToken(String token) {
    setTokenAsync(token).whenComplete(() => null);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Helpers
  //////////////////////////////////////////////////////////////////////////////

  Future<http.MultipartRequest> buildRequest(String method, String endpoint,
      {Map<String, String>? headers}) async {
    headers ??= {};
    headers['Accept'] = 'application/json';

    var request =
        http.MultipartRequest(method, Uri.parse('$baseAddress/$endpoint'));
    request.headers.addAll(headers);
    return request;
  }

  Future<http.MultipartRequest> buildAuthenticatedRequest(
      String method, String endpoint,
      {Map<String, String>? headers}) async {
    headers ??= {};

    String? token = await getTokenAsync();
    if (token == null) throw Exception('Unauthenticated! No token found');
    headers['Authorization'] = 'Bearer $token';

    return buildRequest(method, endpoint, headers: headers);
  }

  String get baseAddress => '$host/api/$version';
}
