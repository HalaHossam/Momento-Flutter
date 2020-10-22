import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/roundedButton.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this, /*upperBound: 100.0*/
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.slowMiddle);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/PngItem_5070798.png'),
                    height: animation.value * 100,
                    //60.0,
                  ),
                ),
                ColorizeAnimatedTextKit(
                  text: ["Momento"],
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  colors: [
                    Colors.purple,
                    Colors.blue,
                    Colors.yellow,
                    Colors.red,
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              colour: Colors.blueAccent,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
