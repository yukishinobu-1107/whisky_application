import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final List<Tab> tabs;
  final List<Widget> tabViews;

  const CustomTabBar({
    required this.tabController,
    required this.tabs,
    required this.tabViews,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: widget.tabController,
          isScrollable: true,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: 4.0, color: Colors.amber[800]!),
            insets: EdgeInsets.symmetric(horizontal: 16.0),
          ),
          labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelColor: Colors.white70,
          labelColor: Colors.amber[800],
          tabs: widget.tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: widget.tabController,
            children: widget.tabViews,
          ),
        ),
      ],
    );
  }
}
