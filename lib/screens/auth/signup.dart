import 'package:flutter/material.dart';
import 'package:memeflix/responsive.dart';
import 'package:memeflix/screens/auth/auth_services.dart';
import 'package:memeflix/screens/auth/login.dart';

class SingUpPage extends StatelessWidget {
  String email;
  String password;
  final formkey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Image.asset(
                'assets/memeflix_header.png',
                width: 320,
              ),
            ),
            Form(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          this.email = value;
                        },
                        style: TextStyle(color: themeGreen),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: themeGreen)),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: themeOrange),
                            labelText: 'Email',
                            hintText: 'Enter valid mail id as abc@gmail.com'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      width: 300,
                      child: TextFormField(
                        onChanged: (value) {
                          this.password = value;
                        },
                        style: TextStyle(color: themeGreen),
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: themeGreen)),
                            hintStyle: TextStyle(color: Colors.grey),
                            labelStyle: TextStyle(color: themeOrange),
                            labelText: 'Password',
                            hintText: 'Enter your secure password'),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                        color: themeGreen,
                        borderRadius: BorderRadius.circular(10)),
                    // ignore: deprecated_member_use
                    child: FlatButton(
                      onPressed: () {
                        AuthServices().singUp(context, email, password);
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // ignore: deprecated_member_use
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text(
                  'Already have a account? Log in.',
                  style: TextStyle(color: themeOrange, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
