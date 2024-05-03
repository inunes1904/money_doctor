import 'package:flutter/material.dart';
import 'package:money_doctor/widgets/income/Income.dart';

class IncomesListExample {
  final List<Income> incomesList = [
    Income(1225.00),
    Income(355.00),
    Income(15.00),
    Income(1225.00),
    Income(355.00),
    Income(15.00),
  ];

  final List<Row> _incomesRows = [];

  double get totalAmount {
    return incomesList.fold(0.0, (double sum, Income income) => sum + income.value);
  }

  IncomesListExample() {
    for (Income income in incomesList) {
      String incomeVal = "${income.value} €";
      _incomesRows.add(Row(
        children: [
          const Icon(
            Icons.add,
            color: Colors.greenAccent,
          ),
          const SizedBox(width: 5),
          Text(
            incomeVal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          )
        ],
      ));
    }
  }

  List<Row> get incomesRows => _incomesRows;
}
