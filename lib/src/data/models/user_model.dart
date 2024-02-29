import 'dart:convert';

import 'package:tdd_clean_architecture/core/utils/typedef.dart';
import 'package:tdd_clean_architecture/src/domain/entities/user.dart';

class UserModel extends User {
  const UserModel(
      {required super.id,
      required super.name,
      required super.avatar,
      required super.createdAt});

  const UserModel.empty()
      : this(id: '1', name: 'name', avatar: 'avatar', createdAt: 'createdAt');

  UserModel.fromMap(DataMap map)
      : this(
          createdAt: map['createdAt'],
          name: map['name'],
          avatar: map['avatar'],
          id: map['id'],
        );

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(jsonDecode(source));

  DataMap toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['createdAt'] = createdAt;
    return data;
  }

  UserModel copyWith(
      {String? avatar, String? name, String? id, String? createdAt}) {
    return UserModel(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
        createdAt: createdAt ?? this.createdAt);
  }

  String toJson() => jsonEncode(toMap());
}
