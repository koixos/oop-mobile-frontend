import 'package:flutter/material.dart';
import '../profile/profile_page.dart';
import '../widgets/custom_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({ super.key });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: Center(
        child: CustomButton(
          text: "Profile", 
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
          }
        ),
      ),
    );
  }
}