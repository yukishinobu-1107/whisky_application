import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../home_list.dart';
import '../model/get_home_list.dart';

import 'home_head.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final list = [];
  String userIcon = "";
  String userName = "";
  String mainText = "";
  String postTime = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // loadJsonAsset().then((val) => {
    //       for (var i = 0; i < val.length; i++)
    //         {
    //           for (var k = 0; k < val[i]["home"].length; k++)
    //             {
    //               print(val[i]["home"][k]),
    //               list.add(val[i]["home"][k]),
    //               setState(() {
    //                 userIcon = val[i]["home"][k]["post_user_icon"];
    //                 userName = val[i]["home"][k]["post_user"];
    //                 mainText = val[i]["home"][k]["post_details"];
    //                 postTime = val[i]["home"][k]["post_time"];
    //               })
    //             }
    //         }
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //backgroundColor: Colors.black,
          body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 170, width: 500, child: HomeHead()),
            const SizedBox(
              child: Divider(),
            ),
            //HomeList(context, userIcon, userName, mainText, postTime)
            HomeListView()
          ],
        ),
      )),
    );
  }
}
