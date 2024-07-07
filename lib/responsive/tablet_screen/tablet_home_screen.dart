import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:skyguru/responsive/mobile_screen/mobile_search_screen.dart';
import 'package:skyguru/responsive/responsive_layout.dart';
import 'package:skyguru/responsive/tablet_screen/tablet_search_screen.dart';

class TabletHomeScreen extends StatefulWidget {
  const TabletHomeScreen({super.key});

  @override
  State<TabletHomeScreen> createState() => _TabletHomeScreenState();
}

class _TabletHomeScreenState extends State<TabletHomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E131F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E131F),
        leading: Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Icon(
            Icons.menu,
            color: Colors.white,
            size: 4.5.h,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _locateMe();
            },
            child: FadeTransition(
              opacity: _animationController,
              child: Icon(
                Icons.location_on_outlined,
                color: Colors.white,
                size: 4.5.h,
              ),
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          GestureDetector(
            onTap: () {
              _navigatePage();
            },
            child: Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Icon(
                Icons.search_outlined,
                color: Colors.white,
                size: 4.5.h,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 2.h,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      _navigatePage();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(40),
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.search_outlined,
                                color: Colors.white,
                                size: 3.5.h,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Enter the name of city',
                                style: TextStyle(
                                  color: const Color.fromARGB(190, 255, 241, 241),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.map_rounded,
                            color: Colors.white,
                            size: 3.5.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: Colors.white,
                    size: 15.h,
                  ),
                  Text(
                    "Use GPS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigatePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ResponsiveLayout(
          mobileScreen: MobileSearchScreen(),
          tabletScreen: TabletSearchScreen(),
        ),
      ),
    );
  }

  void _locateMe() {}
}
