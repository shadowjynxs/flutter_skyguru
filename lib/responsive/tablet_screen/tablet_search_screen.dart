// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TabletSearchScreen extends StatefulWidget {
  const TabletSearchScreen({super.key});

  @override
  State<TabletSearchScreen> createState() => _TabletSearchScreenState();
}

class _TabletSearchScreenState extends State<TabletSearchScreen> {
  bool _isExpanded = false;
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'Flutter',
    'Dart',
    'Animations',
    'State Management',
    'Firebase',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: _isExpanded ? MediaQuery.of(context).size.width * 0.9 : 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(25),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 8),
                _isExpanded
                    ? Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _recentSearches.add(value);
                              });
                            }
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        _isExpanded
            ? Expanded(
                child: ListView.builder(
                  itemCount: _recentSearches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_recentSearches[index]),
                      onTap: () {
                        _searchController.text = _recentSearches[index];
                      },
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}