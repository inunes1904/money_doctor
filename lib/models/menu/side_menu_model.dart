import 'package:flutter/material.dart';

class MenuOptions {
  MenuOptions({
    required this.icon,
    required this.title,
    required this.needLogin,
    required this.showAfterLogin,
    required this.link,
  });

  final Icon icon;
  final String title;
  final bool needLogin;
  final bool showAfterLogin;
  final String link;
}