import 'package:flutter/material.dart';

class NewsProvider extends ChangeNotifier {
  final List<News> _news = [
    News(
        title: "COVID-19 Vaccination Drive Started",
        date: "2025-06-10"),
    News(
        title: "Health Camp on Diabetes Awareness",
        date: "2025-06-08"),
    News(
        title: "New MRI Machine Installed",
        date: "2025-06-05"),
  ];

  List<News> get news => List.unmodifiable(_news);

  Future<void> fetchNews() async {
    // In real app, fetch news from API.
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }
}

class News {
  final String title;
  final String date;

  News({required this.title, required this.date});
}