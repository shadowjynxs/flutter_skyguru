// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/responsive/mobile_screen/mobile_home_screen.dart';
import 'package:skyguru/responsive/responsive_layout.dart';
import 'package:skyguru/responsive/tablet_screen/tablet_home_screen.dart';

class TabletSplashScreen extends StatelessWidget {
  const TabletSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AnimatedSplashScreen(
      backgroundColor: Colors.grey.shade400,
      splashIconSize: height,
      splashTransition: SplashTransition.scaleTransition,
      animationDuration: Duration(microseconds: 750000),
      splash: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 33.w,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.blue.shade300,
                    Colors.red.shade100,
                    Colors.grey.shade400,
                  ],
                ),
              ),
              child: Lottie.asset(
                'lib/assets/logo.json',
                fit: BoxFit.contain,
                frameRate: FrameRate(120),
                renderCache: RenderCache.raster,
              ),
            ),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: Duration(seconds: 2),
              builder: (context, double value, child) {
                return Stack(
                  children: [
                    Text(
                      'SkyGuru',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        foreground: Paint()..color = Colors.grey.withAlpha(100),
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          stops: [value, value],
                          colors: [Colors.blue, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(
                          Rect.fromLTWH(
                            0,
                            0,
                            rect.width,
                            rect.height,
                          ),
                        );
                      },
                      blendMode: BlendMode.srcATop,
                      child: Text(
                        'SkyGuru',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SpinKitThreeBounce(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      nextScreen: ResponsiveLayout(
        mobileScreen: MobileHomeScreen(),
        tabletScreen: TabletHomeScreen(),
      ),
      duration: 2000,
    );
  }
}
