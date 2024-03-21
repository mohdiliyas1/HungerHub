import 'package:flutter/material.dart';
import 'package:hungerhub/main.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MyFormState();
  }
}

class MyFormState extends State<RegistrationPage> {
  final _myFormKey = GlobalKey<FormState>();
  final _mobileNo = TextEditingController();
  final _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Registeration Form",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w500)),
          centerTitle: true,
          backgroundColor: Colors.orange,
          elevation: 5.0,
        ),
        body: SingleChildScrollView(
          child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
              child: Form(
                  key: _myFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            validator: (String? msg) {
                              if (msg == null || msg.isEmpty) {
                                return "Please enter name";
                              }
                              if (msg.length < 3) {
                                return "Name is less than 3 characters";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Name",
                              hintText: "Enter your name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: _mobileNo,
                            validator: (String? num) {
                              if (num == null || num.isEmpty) {
                                return "Number cannot be empty";
                              }
                              if (num.length != 10) {
                                return "Please enter valid mobile number";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Mobile",
                              hintText: "Enter your mobile number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (String? num) {
                              if (num == null || num.isEmpty) {
                                return "Please Confirm your Mobile Number";
                              }
                              if (num != _mobileNo.value.text) {
                                return "Mobile numbers don't match";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              labelText: "Confirm Mobile",
                              hintText: "Confirm your mobile number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            controller: _password,
                            validator: (String? pwd) {
                              if (pwd == null || pwd.isEmpty) {
                                return "Please Enter your Password";
                              }
                              if (pwd.length < 6) {
                                return "Password Length is too small";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Set Password",
                              hintText: "Enter your Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            validator: (String? pwd) {
                              if (pwd == null || pwd.isEmpty) {
                                return "Please Confirm your Password";
                              }
                              if (pwd != _password.value.text) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              hintText: "Enter your Password",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                            )),
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        onPressed: () {
                          if (_myFormKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Registration successful'),
                              duration: Duration(seconds: 2),
                            ));
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MyHomePage()));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          elevation: 3.0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Register",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white)),
                            SizedBox(width: 10.0),
                            Icon(Icons.app_registration, color: Colors.white),
                          ],
                        ),
                      )
                    ],
                  ))),
        ));
  }
}
