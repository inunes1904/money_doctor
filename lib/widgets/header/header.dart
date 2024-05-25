import 'package:flutter/material.dart';

class AppBarPublic extends AppBar {
  AppBarPublic({super.key})
      : super(
          leadingWidth: 35,
          title: Container(
            margin: const EdgeInsets.only(
              top: 0,
              bottom: 0,
              left: 0,
            ),
            child: Image.asset('assets/images/logo-without-icon.png', width: 180),
          ),
        );
}
