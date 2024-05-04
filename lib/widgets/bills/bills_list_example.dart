import 'package:flutter/material.dart';
import 'package:money_doctor/widgets/bills/bill.dart';

class BillsListExample {
  List<Bill> billsList = [
    Bill(125.00),
    Bill(2225.00),
    Bill(325.00),
    Bill(125.00),
    Bill(25.00),
    Bill(425.00)
  ];

  final List<Row> _billsRows = [];

  double get totalAmount {
    return billsList.fold(0.0, (double sum, Bill bill) => sum + bill.value);
  }

  BillsListExample() {
    for (Bill bill in billsList) {
      String billVal = "${bill.value} €";
      _billsRows.add(Row(
        children: [
          const Icon(Icons.remove, color: Colors.red),
          const SizedBox(width: 5),
          Text(
            billVal,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          )
        ],
      ));
    }
  }

  List<Row> get billsRows => _billsRows; 
}
