import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../resources/images.dart';
import '../router/app_router.dart';
import '../utils/utils.dart';

@RoutePage()
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  @override
  SplashScreenPageState createState() => SplashScreenPageState();
}

class SplashScreenPageState extends State<SplashScreenPage>
    with TickerProviderStateMixin {
  double? height;
  bool isFirst = true;
  bool isVisible = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // zoom ➜ dézoom ➜ zoom...

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _navigate();
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      isFirst = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(Utils.getImagePath(DeliveryImage.background) ),
            ), // chemin de ton image
          ),

          child: RotationTransition(
            turns: _animation,
            child:  Align(
            alignment: Alignment.center,
            child: Image(
              image: AssetImage(Utils.getImagePath(DeliveryImage.logo)),
              height: 120,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  _navigate() async {
    try {
      bool? isFirst = await Utils.getIsFirst();
      isFirst != null
          ? await Utils.setisFirst(false)
          : await Utils.setisFirst(true);
      await Utils.getMeFromShared();
      bool isConnected =
          await Utils.getCachedToken() != null && Utils.getMe() != null
          ? true
          : false;
      print("isConnected $isConnected");
      await Future.delayed(const Duration(seconds: 6), () {
        _controller.dispose();
        isConnected == false
            ? context.router.replaceAll([LoginRoute()])
            : context.router.replaceAll([LoginRoute()]);
      });
    } catch (e) {
      print("exception $e");
    }
  }
}
