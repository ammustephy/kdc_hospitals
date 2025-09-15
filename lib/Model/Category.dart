import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String imageUrl;
  final Widget? page;


  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.page,
  });
}
