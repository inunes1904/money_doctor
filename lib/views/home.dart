import 'package:flutter/material.dart';

import '../widgets/bills/bills_list_example.dart';
import '../widgets/income/incomes_list_example.dart';

BillsListExample billsListExample = BillsListExample();
IncomesListExample incomesListExample = IncomesListExample();

class Home extends StatelessWidget {
  const Home({super.key});

// Métodos de totais
  double getBillsTotal() {
    return billsListExample.totalAmount;
  }

  double getIncomesTotal() {
    return incomesListExample.totalAmount;
  }

  double getTotalDifference() {
    // A diferença entre receitas e despesas
    return getIncomesTotal() - getBillsTotal();
  }

  @override
  Widget build(BuildContext context) {
    double billsTotal = getBillsTotal();
    double incomesTotal = getIncomesTotal();
    double totalDifference = getTotalDifference();

    return MaterialApp(
      title: "MONEY DOCTOR",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("images/background.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.1),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    const Center(
                      child: Image(
                        image: AssetImage("images/logo.png"),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          SizedBox(width: 11),
                          Text("BILL VALUE"),
                          TextButton(onPressed: null, child: Icon(Icons.add)),
                          SizedBox(width: 47),
                          Text("INCOME VALUE"),
                          TextButton(onPressed: null, child: Icon(Icons.add)),
                        ],
                      ),
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons.money_off,
                          color: Colors.red,
                          size: 50,
                        ),
                        Text(
                          "YOUR BILLS",
                          style: TextStyle(fontSize: 20, color: Colors.black45),
                        ),
                        SizedBox(width: 30),
                        Icon(
                          Icons.monetization_on_sharp,
                          color: Colors.greenAccent,
                          size: 50,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                          child: Text(
                            "INCOMES",
                            style:
                                TextStyle(fontSize: 20, color: Colors.black45),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 48,
                        ),
                        Expanded(
                          child: Column(
                            children: billsListExample.billsRows,
                          ),
                        ),
                        const SizedBox(
                          width: 73,
                        ),
                        Expanded(
                          child: Column(
                            children: incomesListExample.incomesRows,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      children: [
                        const SizedBox(
                          width: 48,
                        ),
                       Expanded(child: Center(child: Text("- $billsTotal €", style: const TextStyle(fontSize: 18, color: Colors.red),))),
                        
                        const SizedBox(
                          width: 73,
                        ),
                        Expanded(child: Center(child: Text("$incomesTotal €", style: const TextStyle(fontSize: 18, color: Colors.green),))),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    const Center(child: Text("Saldo:", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black45),)),

                    const SizedBox(height: 2,),

                    Center(child: Text("$totalDifference €", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green),))
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
