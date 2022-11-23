// Copyright 2022, Poliisiauto developers.

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
  final _storage = const FlutterSecureStorage();

  PoliisiautoApi({required this.host, required this.version});

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

    if (_isOk(response)) {
      return await response.stream.bytesToString();
    }

    return null;
  }

  Future<bool> sendLogout() async {
    var request = await buildAuthenticatedRequest('POST', 'logout');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      await _storage.delete(key: 'bearer_token');
      return true;
    }

    return false;
  }

  Future<Organization> fetchAuthenticatedUserOrganization() async {
    var request =
        await buildAuthenticatedRequest('GET', 'profile/organization');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      return Organization.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    }

    throw Exception(
        'Failed to load authenticated user: $response.reasonPhrase');
  }

  Future<User> fetchAuthenticatedUser() async {
    var request = await buildAuthenticatedRequest('GET', 'profile');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      return User.fromJson(jsonDecode(await response.stream.bytesToString()));
    }

    throw Exception(
        'Failed to load authenticated user: $response.reasonPhrase');
  }

  Future<Organization> fetchOrganization(int organizationId) async {
    var request =
        await buildAuthenticatedRequest('GET', 'organizations/$organizationId');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      return Organization.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    }

    throw Exception('Failed to load organization: $response.reasonPhrase');
  }

  Future<List<Report>> fetchReports() async {
    var request = await buildAuthenticatedRequest('GET', 'reports');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      final List<dynamic> reportsJson =
          jsonDecode(await response.stream.bytesToString());

      List<Report> reports = [];
      for (var reportJson in reportsJson) {
        reports.add(Report.fromJson(reportJson));
      }

      return reports;
    }

    throw Exception('Failed to load reports: $response.reasonPhrase');
  }

  Future<Report> fetchReport(int reportId) async {
    var request = await buildAuthenticatedRequest('GET', 'reports/$reportId');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
    }

    throw Exception('Failed to load report: $response.reasonPhrase');
  }

  Future<bool> storeReport(Report report) async {
    return Future.delayed(const Duration(seconds: 0), () {
      print('$report');
      return false;
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Bearer Token
  //////////////////////////////////////////////////////////////////////////////

  Future<void> setTokenAsync(String token) async {
    _storage.write(key: 'bearer_token', value: token);
  }

  Future<String?> getTokenAsync() async {
    return _storage.read(key: 'bearer_token');
  }

  /// Synchronously set token.
  void setToken(String token) {
    setTokenAsync(token).whenComplete(() => null);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Helpers
  //////////////////////////////////////////////////////////////////////////////

  Future<bool> hasTokenStored() async {
    return (await getTokenAsync() != null);
  }

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
  bool _isOk(http.BaseResponse response) =>
      200 <= response.statusCode && response.statusCode < 300;
}
