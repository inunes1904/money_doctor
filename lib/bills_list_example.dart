import 'dart:core';
import 'package:flutter/material.dart';

import 'bill.dart';

class BillsListExample{

  List<Bill> billsList = [
    Bill(25.00),Bill(25.00),Bill(325.00),Bill(125.00),Bill(25.00),Bill(425.00)
  ];

  final List<Row> _billsRows = [];

  BillsListExample(){
    for (Bill bill in billsList) {
      String billVal = "${bill.value} €";
      _billsRows.add( Row(
            children: [
              const Icon(Icons.remove, color: Colors.red),
              const SizedBox(width: 5),
              Text(
                "${bill.value} €",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              )
            ],
          )
      );
    }

  }

  List<Row> get billsRows => _billsRows;
}
