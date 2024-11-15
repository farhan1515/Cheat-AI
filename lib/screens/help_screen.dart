import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "help",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(color: Colors.blue),
              child: ListTile(
                title: Center(child: Text("About Us")),
                onTap: () {},
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(color: Colors.white),
              child: ListTile(
                title: Text("2tile"),
                onTap: () {},
              ),
            ),
          )
        ],
      ),
    );
  }
}
