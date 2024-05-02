import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:money_doctor/bills_list_example.dart';
import 'package:money_doctor/incomes_list_example.dart';

BillsListExample billsListExample = BillsListExample();
IncomesListExample incomesListExample = IncomesListExample();

void main() {
  runApp(MoneyDoctorApp());
}


class MoneyDoctorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation',
      initialRoute: '/',
      routes: {
        '/': (context) => MoneyDoctorHome(),
        '/moneydoctor': (context) => MoneyDoctor(),
      },
    );
  }
}


class MoneyDoctorHome extends StatelessWidget {
  const MoneyDoctorHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MONEY DOCTOR",
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("images/backgroundHome.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.dstATop,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage(
                        "images/logo.png"
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                        child: ElevatedButton(
                          style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.indigo.shade900),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0), // Set rounded corner radius
                              ),
                            ),
                          ),
                          onPressed: () {
                            // Navigate to the second page when the button is pressed
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MoneyDoctor()),
                            );
                          },
                          child: Text('ENTER'),
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
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
              Colors.black.withOpacity(0.1),
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
            SizedBox(width:30),
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
            const SizedBox(width: 73,),
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
