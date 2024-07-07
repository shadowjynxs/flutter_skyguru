// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/blocs/weather/weather_bloc.dart';
import 'package:skyguru/blocs/weather/weather_event.dart';
import 'package:skyguru/blocs/weather/weather_state.dart';
import 'package:skyguru/repositories/weather_repository.dart';
import 'package:skyguru/responsive/mobile_screen/mobile_weather_screen.dart';
import 'package:skyguru/responsive/responsive_layout.dart';
import 'package:skyguru/responsive/tablet_screen/tablet_weather_screen.dart';

class MobileSearchScreen extends StatefulWidget {
  const MobileSearchScreen({super.key});

  @override
  State<MobileSearchScreen> createState() => _MobileSearchScreenState();
}

class _MobileSearchScreenState extends State<MobileSearchScreen> {
  List<String> _recentSearch = [];

  final TextEditingController _searchController = TextEditingController();
  final WeatherBloc _weatherBloc = WeatherBloc(weatherRepository: WeatherRepository());

  @override
  void initState() {
    _loadRecentSearch();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.clear();
    _searchController.dispose();
    _weatherBloc.close();
    super.dispose();
  }

  Future<void> _loadRecentSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearch = prefs.getStringList('recentSearch') ?? [];
    });
  }

  Future<void> _updateRecentSearchInPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearch', _recentSearch);
  }

  Future<void> _saveRecentSearch(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedList = prefs.getStringList('recentSearch') ?? [];
    savedList.remove(cityName);
    savedList.insert(0, cityName);

    await prefs.setStringList('recentSearch', savedList);

    setState(() {
      _recentSearch = savedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E131F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E131F),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.only(
                left: 2.w,
                right: 2.w,
              ),
              child: Icon(
                Icons.keyboard_backspace_outlined,
                color: Colors.white,
                size: 4.h,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 1.w,
                right: 3.w,
                top: 1.w,
                bottom: 1.w,
              ),
              child: TextField(
                controller: _searchController,
                textAlignVertical: TextAlignVertical.center,
                autofocus: true,
                cursorColor: Colors.orange,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      startSearch(_searchController.text);
                    },
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.white,
                    ),
                  ),
                  hintText: "Enter the name of city",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  fillColor: Color(0xFF0E131F),
                  filled: true,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<WeatherBloc, WeatherState>(
        bloc: _weatherBloc,
        listener: (context, state) {
          if (state is WeatherLoaded) {
            _saveRecentSearch(state.weather.cityName);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ResponsiveLayout(
                  mobileScreen: MobileWeatherScreen(),
                  tabletScreen: TabletWeatherScreen(),
                ),
                settings: RouteSettings(arguments: state.weather),
              ),
            );
          } else if (state is WeatherError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  '${state.message} for City ${_searchController.text}. Please Enter Correct City Name',
                ),
              ),
            );
            _weatherBloc.add(ResetWeather());
          }
        },
        child: BlocBuilder<WeatherBloc, WeatherState>(
          bloc: _weatherBloc,
          builder: (context, state) {
            if (state is WeatherLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return _recentSearch.isEmpty
                ? Container()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: 3.w,
                          top: 2.h,
                          bottom: 0.5.h,
                        ),
                        child: Text(
                          "Recent Search",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 0.6,
                        color: Colors.grey.shade300,
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            String cityName = _recentSearch[index];
                            return GestureDetector(
                              onTap: () {
                                startSearch(cityName);
                                setState(() {
                                  _searchController.text = cityName;
                                });
                              },
                              child: Dismissible(
                                key: Key(cityName),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(right: 20),
                                  color: Colors.red,
                                  child: Icon(Icons.delete, color: Colors.white),
                                ),
                                onDismissed: (direction) {
                                  setState(() {
                                    _recentSearch.removeAt(index);
                                  });
                                  _updateRecentSearchInPrefs();
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 0.5,
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            cityName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _recentSearch.removeAt(index);
                                              });
                                              _updateRecentSearchInPrefs();
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          itemCount: _recentSearch.length,
                        ),
                      )
                    ],
                  );
          },
        ),
      ),
    );
  }

  void startSearch(String cityName) {
    if (cityName.isNotEmpty) {
      _weatherBloc.add(FetchWeather(cityName: cityName));
    }
  }
}
