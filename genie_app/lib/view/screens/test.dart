import 'package:flutter/material.dart';
import 'package:genie_app/view/widgets/follow_button.dart';
import 'package:genie_app/viewModel/controllerSocial.dart';

class TestScreen extends StatelessWidget {

  final Future<int> response = ControllerSocial.checkRequestsFollowing('66723eb514485f865f000000');
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Follow Button Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<int>(
              future: response,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return FollowButton(response: snapshot.data!, followedUserId: '66723eb514485f865f000000',);
                }
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}