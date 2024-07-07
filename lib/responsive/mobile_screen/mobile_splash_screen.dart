import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/responsive/mobile_screen/mobile_home_screen.dart';
import 'package:skyguru/responsive/responsive_layout.dart';
import 'package:skyguru/responsive/tablet_screen/tablet_home_screen.dart';

class MobileSplashScreen extends StatelessWidget {
  const MobileSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return AnimatedSplashScreen(
      backgroundColor: Colors.grey.shade400,
      splashIconSize: 100.h,
      splashTransition: SplashTransition.scaleTransition,
      animationDuration: const Duration(microseconds: 750000),
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 50.w,
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
              frameRate: const FrameRate(120),
              renderCache: RenderCache.raster,
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, double value, child) {
              return Stack(
                children: [
                  Text(
                    'SkyGuru',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()..color = Colors.grey.withAlpha(100),
                    ),
                  ),
                  ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        stops: [value, value],
                        colors: const [Colors.blue, Colors.white],
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
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SpinKitThreeBounce(
            color: Colors.blue,
          ),
        ],
      ),
      nextScreen: const ResponsiveLayout(
        mobileScreen: MobileHomeScreen(),
        tabletScreen: TabletHomeScreen(),
      ),
      duration: 2000,
    );
  }
}
