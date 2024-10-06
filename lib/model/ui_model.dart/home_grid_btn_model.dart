// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class HomeGridBtnModel {
  final IconData icon;
  final String label;

  HomeGridBtnModel({
    required this.icon,
    required this.label,
  });

  HomeGridBtnModel copyWith({
    IconData? icon,
    String? label,
  }) {
    return HomeGridBtnModel(
      icon: icon ?? this.icon,
      label: label ?? this.label,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'icon': icon.codePoint,
      'label': label,
    };
  }

  factory HomeGridBtnModel.fromMap(Map<String, dynamic> map) {
    return HomeGridBtnModel(
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      label: map['label'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeGridBtnModel.fromJson(String source) =>
      HomeGridBtnModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HomeGridBtnModel(icon: $icon, label: $label)';

  @override
  bool operator ==(covariant HomeGridBtnModel other) {
    if (identical(this, other)) return true;

    return other.icon == icon && other.label == label;
  }

  @override
  int get hashCode => icon.hashCode ^ label.hashCode;
}
