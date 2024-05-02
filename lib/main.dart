import 'package:flutter/material.dart';
import 'package:money_doctor/bills_list_example.dart';
import 'package:money_doctor/incomes_list_example.dart';

BillsListExample billsListExample = BillsListExample();
IncomesListExample incomesListExample = IncomesListExample();

void main() {
  runApp(const MoneyDoctor());
}

class MoneyDoctor extends StatelessWidget {
  const MoneyDoctor({super.key});

  @override
  Widget build(BuildContext context) {
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
              Colors.black.withOpacity(0.1), // Adjust opacity as needed (0.0 - fully transparent, 1.0 - fully opaque)
              BlendMode.dstATop,
            ),
            ),
          ),
          child: const SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: BillsPage(),
            ),
          ),
        ),
      ),
    );
  }
}


class BillsPage extends StatefulWidget {
  const BillsPage({super.key});

  @override
  State<BillsPage> createState() => _BillsPageState();
}

class _BillsPageState extends State<BillsPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Image(
            image: AssetImage(
                "images/logo.png"
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top:30),
          child: Row(
            children: [
              SizedBox(width:11),
              Text("BILL VALUE"),
              TextButton(
                  onPressed: null,
                  child: Icon(
                      Icons.add
                  )
              ),
              SizedBox(width:47),
              Text("INCOME VALUE"),
              TextButton(
                  onPressed: null,
                  child: Icon(
                      Icons.add
                  )
              ),
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
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.black45
              ),
            ),
            SizedBox(width:40),
            Icon(
              Icons.monetization_on_sharp,
              color: Colors.greenAccent,
              size: 50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
              child: Text(
                "INCOMES",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black45
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 48,),
            Expanded(
              child: Column(
                children: billsListExample.billsRows,
              ),
            ),
            const SizedBox(width: 88,),
            Expanded(
              child: Column(
                children: incomesListExample.incomesRows,
              ),
            ),
          ],
        )
      ],
    );
  }

}
