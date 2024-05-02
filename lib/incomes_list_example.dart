import 'dart:core';
import 'package:flutter/material.dart';
import 'package:money_doctor/Income.dart';

class IncomesListExample{

  List<Income> _incomesList = [
    Income(1225.00),Income(355.00),Income(15.00),Income(1225.00),Income(355.00),Income(15.00),
  ];

  final List<Row> _incomesRows = [];

  IncomesListExample(){
    for (Income income in _incomesList) {
      String billVal = "${income.value} €";
      _incomesRows.add( Row(
        children: [
          Icon(Icons.add, color: Colors.greenAccent, ),
          const SizedBox(width: 5),
          Text(
            "${income.value} €",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          )
        ],
      )
      );
    }
  print(_incomesRows);
  }

  List<Row> get incomesRows => _incomesRows;
}
