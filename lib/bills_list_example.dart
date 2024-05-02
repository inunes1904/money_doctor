import 'dart:core';
import 'package:flutter/material.dart';

import 'bill.dart';

class BillsListExample{

  List<Bill> billsList = [
    Bill(25.00),Bill(25.00),Bill(325.00),Bill(125.00),Bill(25.00),Bill(425.00)
  ];

  List<Row> testing = [

    const Row(
      children: [
        SizedBox(width: 80),
        Icon(Icons.remove),
        SizedBox(width: 5),
        Text('Favorite'),
      ],
    ),
    const Row(
      children: [
        SizedBox(width: 80),
        Icon(Icons.remove),
        SizedBox(width: 5),
        Text('Favorite'),
      ],
    )

  ];

  final List<Row> _billsRows = [];

  BillsListExample(){
    for (Bill bill in billsList) {
      _billsRows.add(
           const Row(
            children: [
              SizedBox(width: 80),
              Icon(Icons.remove),
              SizedBox(width: 5),
              Text('Favorite'),
            ],
          )
      );
    }
    print(_billsRows);
  }

  List<Row> get billsRows => _billsRows;
}
