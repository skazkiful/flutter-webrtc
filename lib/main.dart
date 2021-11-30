import 'package:flutter/material.dart';
import 'package:flutter_sandbox/call.dart';

void main() {
  runApp(MyApp());
}

///Initialize MyApp Class
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/home",
      routes: {
        "/home": (BuildContext context) => MyHomePage(),
        "/call": (BuildContext context) => CallPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.white,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Material(
          color: Color(0xFF757DE8),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            key: Key('join'),
            onTap: () {
              Navigator.of(context).pushNamed("/call");
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              width: 339,
              height: 50,
              child: Text(
                "Join",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
