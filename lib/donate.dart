import 'package:flutter/material.dart';
import 'registrationpage.dart';

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Donate',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
              )),
          centerTitle: true,
          backgroundColor: Colors.green,
          elevation: 5.0),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Make a Difference with a Click',
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.green,
            )),
        const SizedBox(
          height: 40,
        ),
        SizedBox(
            width: 300,
            height: 250,
            child: Card(
              color: Colors.white,
              elevation: 5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Donate Now!',
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.blueAccent,
                        )),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistrationPage()),
                        );
                      },
                      child: const Text(
                        'DONATE',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                        "Your small act of kindness \ncan make a big difference.",
                        style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
                  ]),
            )),
        const SizedBox(height: 120),
        const Text("Did you know?",
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20.0)),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
            child: Text(
                "\nAccording to the World Food Programme, approximately 690 million people worldwide suffer from hunger, with the majority living in developing countries. Your donation can help provide essential meals to those in need and make a difference in the fight against hunger and poverty.",
                textAlign: TextAlign.center))
      ])),
    );
  }
}
