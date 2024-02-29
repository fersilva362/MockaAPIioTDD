import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tdd_clean_architecture/core/errors/exception.dart';
import 'package:tdd_clean_architecture/src/data/models/user_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar});
  Future<List<UserModel>> getUsers();
}

class AuthRemoteDataimpl implements AuthenticationRemoteDataSource {
  final http.Client _client;

  AuthRemoteDataimpl(this._client);
  @override
  Future<void> createUser(
      {required String createdAt,
      required String name,
      required String avatar}) async {
    try {
      final response = await _client
          .post(Uri.parse('https://65ae6f331dfbae409a74d30e.mockapi.io/users'),
              body: jsonEncode({
                'createdAt': createdAt,
                'name': name,
              }),
              headers: {'Content-Type': 'application/json '});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
            message: response.body, statusCode: response.statusCode);
      }
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _client
          .get(Uri.parse('https://65ae6f331dfbae409a74d30e.mockapi.io/users'));
      debugPrint(response.body.toString());

      if (response.statusCode != 200) {
        throw ServerException(
            message: response.body, statusCode: response.statusCode);
      }
      final result = (jsonDecode(response.body) as List)
          .map((ele) => UserModel.fromMap(ele))
          .toList();
      debugPrint(result.toString());

      return result;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: 500);
    }
  }
}
