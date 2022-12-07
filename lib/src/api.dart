/*
 * Copyright (c) 2022, Miika Sikala, Essi Passoja, Lauri Klemettilä
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'data.dart';

/// initialize the global API accessor
PoliisiautoApi api =
    PoliisiautoApi(host: 'https://poliisiauto.spacha.dev', version: 'v1');

class PoliisiautoApi {
  final String host;
  final String version;
  final _storage = const FlutterSecureStorage();

  PoliisiautoApi({required this.host, required this.version});

  //////////////////////////////////////////////////////////////////////////////
  /// API endpoints
  //////////////////////////////////////////////////////////////////////////////

  //////////////////////////////////////////////////////////////////////////////
  /// Auth endpoints
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

  //////////////////////////////////////////////////////////////////////////////
  /// Organization endpoints
  //////////////////////////////////////////////////////////////////////////////

  Future<Organization> fetchOrganization(int organizationId) async {
    var request =
        await buildAuthenticatedRequest('GET', 'organizations/$organizationId');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      return Organization.fromJson(
          jsonDecode(await response.stream.bytesToString()));
    }

    throw Exception('Request failed: ${await response.stream.bytesToString()}');
  }

  Future<List<User>> fetchTeachers() async {
    var request = await buildAuthenticatedRequest('GET', 'teachers');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      final List<dynamic> teachersJson =
          jsonDecode(await response.stream.bytesToString());

      List<User> teachers = [];
      for (var t in teachersJson) {
        teachers.add(User.fromJson(t));
      }

      return teachers;
    }

    throw Exception('Request failed: ${await response.stream.bytesToString()}');
  }

  Future<List<User>> fetchStudents() async {
    var request = await buildAuthenticatedRequest('GET', 'students');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      final List<dynamic> studentsJson =
          jsonDecode(await response.stream.bytesToString());

      List<User> students = [];
      for (var s in studentsJson) {
        students.add(User.fromJson(s));
      }

      return students;
    }

    throw Exception('Request failed: ${await response.stream.bytesToString()}');
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Report endpoints
  //////////////////////////////////////////////////////////////////////////////

  Future<List<Report>> fetchReports(
      {String order = 'DESC', String? route}) async {
    http.MultipartRequest request;
    // FIXME: Throws if logged out from '/reports' as teacher
    try {
      request = await buildAuthenticatedRequest('GET', route ?? 'reports');
    } catch (e) {
      return [];
    }
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      final List<dynamic> reportsJson =
          jsonDecode(await response.stream.bytesToString());

      List<Report> reports = [];
      for (var r in reportsJson) {
        reports.add(Report.fromJson(r));
      }

      // order the reports by creation date
      if (order == 'DESC') {
        reports.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));
      } else {
        reports.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
      }

      return reports;
    }

    throw Exception('Request failed: ${await response.stream.bytesToString()}');
  }

  Future<Report> fetchReport(int reportId) async {
    var request = await buildAuthenticatedRequest('GET', 'reports/$reportId');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      return Report.fromJson(jsonDecode(await response.stream.bytesToString()));
    }

    throw Exception('Request failed: ${await response.stream.bytesToString()}');
  }

  Future<bool> sendNewReport(Report report) async {
    //print('$report');
    var request = await buildAuthenticatedRequest('POST', 'reports');

    request.fields.addAll({
      'description': _stringify(report.description),
      'is_anonymous': _stringify(report.isAnonymous),
      'reporter_id': _stringify(report.reporterId),
      'handler_id': _stringify(report.handlerId),
      'bully_id': _stringify(report.bullyId),
      'bullied_id': _stringify(report.bulliedId),
    });

    http.StreamedResponse response = await request.send();

    // DEBUG: Print response content if the request fails
    if (!_isOk(response)) _dbgPrintResponse(response);

    return _isOk(response);
  }

  Future<bool> deleteReport(int id) async {
    var request = await buildAuthenticatedRequest('DELETE', 'reports/$id');

    http.StreamedResponse response = await request.send();

    return _isOk(response);
  }

  //////////////////////////////////////////////////////////////////////////////
  /// Message endpoints
  //////////////////////////////////////////////////////////////////////////////

  Future<List<Message>> fetchMessages(int reportId) async {
    http.MultipartRequest request;
    request =
        await buildAuthenticatedRequest('GET', 'reports/$reportId/messages');
    http.StreamedResponse response = await request.send();

    if (_isOk(response)) {
      final List<dynamic> messagesJson =
          jsonDecode(await response.stream.bytesToString());

      List<Message> messages = [];
      for (var r in messagesJson) {
        messages.add(Message.fromJson(r));
      }

      // order the messages by creation date
      messages.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      return messages;
    }

    throw Exception('Request failed: ${await response.stream.bytesToString()}');
  }

  Future<bool> sendNewMessage(Message message) async {
    var request = await buildAuthenticatedRequest(
        'POST', 'reports/${message.reportId}/messages');

    request.fields.addAll({
      'content': _stringify(message.content),
      'is_anonymous': _stringify(message.isAnonymous),
      'report_id': _stringify(message.reportId),
      'author_id': _stringify(message.authorId)
    });

    http.StreamedResponse response = await request.send();

    // DEBUG: Print response content if the request fails
    if (!_isOk(response)) _dbgPrintResponse(response);

    return _isOk(response);
  }

  Future<bool> deleteMessage(int id) async {
    //print('$report');
    var request =
        await buildAuthenticatedRequest('DELETE', 'report-messages/$id');

    http.StreamedResponse response = await request.send();

    return _isOk(response);
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

  /// Get the base address of the API.
  String get baseAddress => '$host/api/$version';

  /// Return true if given response is successful.
  bool _isOk(http.BaseResponse response) =>
      200 <= response.statusCode && response.statusCode < 300;

  /// Convert a variable to string as in JSON field.
  String _stringify(dynamic v) {
    if (v == null) return '';
    if (v is String) return v;
    if (v is int) return v.toString();
    if (v is bool) return v ? '1' : '0';

    throw Exception('Cannot _stringify type ${v.runtimeType}');
  }

  void _dbgPrintResponse(http.StreamedResponse response) async {
    print(
        'Error ${response.statusCode}: ${jsonDecode(await response.stream.bytesToString())}');
  }
}
