import 'package:flutter/material.dart';
import 'package:money_doctor/bills_list_example.dart';


void main() {
  runApp(const MoneyDoctor());
}

class MoneyDoctor extends StatelessWidget {
  const MoneyDoctor({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "MONEY DOCTOR",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: BillsPage(),
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

  List<Icon> test = [
    Icon(Icons.remove),
    Icon(Icons.remove),
    Icon(Icons.remove),
    Icon(Icons.remove),
  ];

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Center(
          child: Image(
              image: AssetImage(
                  "images/logo.png"
              ),
          ),
        ),
        Padding(
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
        Row(
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


      ],
    );
  }

}
