import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_clean_architecture/src/data/models/user_model.dart';
import 'package:tdd_clean_architecture/src/domain/entities/user.dart';

import '../../../fixture/fixture_reader.dart';

void main() {
  const tModel = UserModel.empty();
  final tJson = fixture('user.json');
  final tMap = jsonDecode(tJson);
  test('should be a class of [User] entity', () {
    expect(tModel, isA<User>());
  });
  group('fromMap', () {
    test('should retunr a [UserModel] with the rigth data', () {
      final result = UserModel.fromMap(tMap);
      expect(result, equals(tModel));
    });
  });

  group('fromJson', () {});
  test('should retunr a [UserModel] with the rigth data', () {
    final tJson = fixture('user.json');

    final result = UserModel.fromJson(tJson);
    expect(result, equals(tModel));
  });

  group('toMap', () {
    test('should return [Map] with right data', () {
      final result = tModel.toMap();
      expect(result, equals(tMap));
    });
  });

  group('tojson', () {
    test('should return [String] with the right data', () {
      final result = tModel.toJson();
      final tJson = jsonEncode({
        "id": "1",
        "name": "name",
        "avatar": "avatar",
        "createdAt": "createdAt"
      });
      expect(result, equals(tJson));
    });
  });
  group('copyWith', () {
    test('should return [JSON]', () {
      final result = tModel.copyWith(name: 'patricia');
      expect(result.name, equals('patricia'));
    });
  });
}
