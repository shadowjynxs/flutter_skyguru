import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/blocs/weather/weather_bloc.dart';
import 'package:skyguru/repositories/weather_repository.dart';
import 'package:skyguru/responsive/mobile_screen/mobile_splash_screen.dart';
import 'package:skyguru/responsive/responsive_layout.dart';
import 'package:skyguru/responsive/tablet_screen/tablet_splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, type) {
        return BlocProvider<WeatherBloc>(
          create: (context) => WeatherBloc(
            weatherRepository: WeatherRepository(),
          ),
          child: MaterialApp(
            title: 'Weather App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue),
            home: const ResponsiveLayout(
              mobileScreen: MobileSplashScreen(),
              tabletScreen: TabletSplashScreen(),
            ),
          ),
        );
      },
    );
  }
}
