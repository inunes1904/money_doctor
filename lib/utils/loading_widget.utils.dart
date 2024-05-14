import 'package:flutter/material.dart';

abstract class LoadingWidget {
  static Widget getLoadingWidget(BuildContext context, String loadingMsg) {
    return SizedBox(
      height: MediaQuery.of(context).orientation.toString() ==
              "Orientation.portrait"
          ? MediaQuery.of(context).size.height / 1.4
          : MediaQuery.of(context).size.height / 1.7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: CircularProgressIndicator()),
          Text(
            loadingMsg,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
